import 'dart:async';
import 'dart:convert';
import 'package:dart_hub/data/notif.dart';
import 'package:dart_hub/manager/auth_manager.dart';
import 'package:dart_hub/ui/paginated_list_view.dart';

class NotifPaginator extends Paginator<Notif> {

  final AuthManager _authManager;
  final RegExp _nextRegex = new RegExp('<(\.+)>; rel="next"');

  NotifPaginator(this._authManager);

  @override
  Future<Page<Notif>> loadPage(Bookmark bookmark) async {
    var url;
    if (bookmark.payload['next'] == null) {
      url = 'https://api.github.com/notifications';
    } else {
      url = bookmark.payload['next'];
    }

    var oauthClient = _authManager.oauthClient;
    var response = await oauthClient
        .get(url)
        .whenComplete(oauthClient.close);

    if (response.statusCode == 200) {
      var nextBookmark;
      var link = response.headers['link'];
      if (link != null) {
        var match = _nextRegex.firstMatch(link);
        if (match != null) {
          nextBookmark = new Bookmark({'next': match.group(1)});
        }
      }

      return new Page(
          nextBookmark,
          JSON.decode(response.body)
              .map((itemJson) => new Notif.fromJson(itemJson))
              .toList()
      );
    } else {
      throw new Exception('Could not load notifications');
    }
  }
}