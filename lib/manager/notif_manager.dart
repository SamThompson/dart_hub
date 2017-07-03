import 'dart:async';
import 'dart:convert';
import 'package:dart_hub/data/notif.dart';
import 'package:dart_hub/manager/auth_manager.dart';

class NotifManager {

  final AuthManager _authManager;

  NotifManager(this._authManager);

  Future<List<Notif>> loadNotifs() async {
    var oauthClient = _authManager.oauthClient;
    var response = await oauthClient.get('https://api.github.com/notifications')
        .whenComplete(oauthClient.close);

    if (response.statusCode == 200) {
      return JSON.decode(response.body)
          .map((itemJson) => new Notif.fromJson(itemJson))
          .toList();
    } else {
      throw new Exception('Could not load notifications');
    }
  }
}
