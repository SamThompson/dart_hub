import 'dart:async';
import 'dart:convert';
import 'package:dart_hub/data/repo.dart';
import 'package:dart_hub/manager/auth_manager.dart';

class RepoManager {

  final AuthManager _authManager;

  RepoManager(this._authManager);

  Future<Repo> loadRepo(String username, String repo) async {
    var oauthClient = _authManager.oauthClient;
    var response = await oauthClient
        .get('https://api.github.com/repos/${username}/${repo}')
        .whenComplete(oauthClient.close);

    if (response.statusCode == 200) {
      var json = JSON.decode(response.body);
      return new Repo.fromJson(json);
    } else {
      throw response.body;
    }
  }
}