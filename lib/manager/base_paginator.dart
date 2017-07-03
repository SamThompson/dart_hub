import 'dart:async';
import 'dart:convert';
import 'package:dart_hub/manager/auth_manager.dart';
import 'package:dart_hub/ui/paginated_list_view.dart';

abstract class BasePaginator<T> extends Paginator<T> {

  final AuthManager _authManager;
  final String _baseUrl;
  final RegExp _nextRegex = new RegExp('<(\.+)>; rel="next"');

  BasePaginator(this._authManager, this._baseUrl);

  T parseItem(itemJson);

  Future<Page<T>> loadPage(Bookmark bookmark) async {
    var url;
    if (bookmark.payload['next'] == null) {
      url = _baseUrl;
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

      return new Page<T>(
          nextBookmark,
          JSON.decode(response.body)
              .map((itemJson) => parseItem(itemJson))
              .toList()
      );
    } else {
      throw 'Error loading events';
    }
  }
}