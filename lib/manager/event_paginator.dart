import 'dart:async';
import 'dart:convert';
import 'package:dart_hub/data/event.dart';
import 'package:dart_hub/manager/auth_manager.dart';
import 'package:dart_hub/ui/paginated_list_view.dart';

class EventsPaginator extends Paginator<Event> {

  final AuthManager _authManager;
  final RegExp _nextRegex = new RegExp('<(\.+)>; rel="next"');

  EventsPaginator(this._authManager);

  Future<Page<Event>> loadPage(Bookmark bookmark) async {
    var url;
    if (bookmark.payload['next'] == null) {
      url =
      'https://api.github.com/users/${_authManager.username}/received_events';
    } else {
      url = bookmark.payload['next'];
    }

    var oauthClient = _authManager.oauthClient;
    var response = await oauthClient
        .get(url)
        .whenComplete(oauthClient.close);

    if (response.statusCode == 200) {
      var match = _nextRegex.firstMatch(response.headers['link']);
      var nextBookmark;
      if (match != null) {
        nextBookmark = new Bookmark({'next': match.group(1)});
      }

      return new Page(
          nextBookmark,
          JSON.decode(response.body)
              .map((eventJson) => new Event.fromJson(eventJson))
              .toList()
      );
    } else {
      throw 'Error loading events';
    }
  }
}
