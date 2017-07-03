import 'dart:async';

import 'dart:convert';
import 'package:dart_hub/data/user.dart';
import 'package:dart_hub/manager/auth_manager.dart';

class ProfileManager {

  final AuthManager _authManager;

  ProfileManager(this._authManager);

  Future<User> loadUser() async {
    var response = await _authManager.oauthClient.get('https://api.github.com/user');

    if (response.statusCode == 200) {
      var decoded = JSON.decode(response.body);
      return new User.fromJson(decoded);
    } else {
      throw new Exception('Could not get current user');
    }
  }
}