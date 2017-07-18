import 'dart:async';

import 'dart:convert';
import 'package:dart_hub/model/user.dart';
import 'package:dart_hub/interactor/manager/auth_manager.dart';

class ProfileManager {

  final AuthManager _authManager;
  final String _username;

  ProfileManager(this._authManager, this._username);

  Future<User> loadUser() async {
    var oauthClient = _authManager.oauthClient;
    var response = await oauthClient
        .get('https://api.github.com/users/${_username}')
        .whenComplete(oauthClient.close);

    if (response.statusCode == 200) {
      var decoded = JSON.decode(response.body);
      return new User.fromJson(decoded);
    } else {
      throw new Exception('Could not get current user');
    }
  }
}
