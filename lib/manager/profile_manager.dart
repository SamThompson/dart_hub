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
      print(decoded);
      return new User(decoded['id'],
          decoded['name'],
          decoded['login'],
          decoded['avatar_url'],
          decoded['public_repos'],
          decoded['followers'],
          decoded['following']);
    } else {
      throw new Exception('Could not get current user');
    }
  }
}