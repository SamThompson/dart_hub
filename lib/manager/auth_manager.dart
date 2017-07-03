import 'dart:async';
import 'dart:convert';
import 'package:dart_hub/keys.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {

  static const String KEY_USERNAME = 'KEY_USERNAME';
  static const String KEY_OAUTH_TOKEN = 'KEY_AUTH_TOKEN';

  bool get initialized => _initialized;

  bool get loggedIn => _loggedIn;

  String get username => _username;

  OauthClient get oauthClient => _oauthClient;

  final String _clientId = CLIENT_ID;
  final String _clientSecret = CLIENT_SECRET;
  final Client _client = new Client();
  bool _initialized;
  bool _loggedIn;
  String _username;
  OauthClient _oauthClient;

  Future init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString(KEY_USERNAME);
    String oauthToken = prefs.getString(KEY_OAUTH_TOKEN);

    if (username == null || oauthToken == null) {
      _loggedIn = false;
      await logout();
    } else {
      _loggedIn = true;
      _username = username;
      _oauthClient = new OauthClient(_client, oauthToken);
    }

    _initialized = true;
  }

  Future<bool> login(String username, String password) async {
    var basicToken = _getEncodedAuthorization(username, password);
    final requestHeader = {
      'Authorization': 'Basic ${basicToken}'
    };
    final requestBody = JSON.encode({
      'client_id': _clientId,
      'client_secret': _clientSecret,
      'scopes': ['user', 'repo', 'notifications']
    });

    final loginResponse = await _client.post(
        'https://api.github.com/authorizations',
        headers: requestHeader,
        body: requestBody)
        .whenComplete(_client.close);

    if (loginResponse.statusCode == 201) {
      final bodyJson = JSON.decode(loginResponse.body);
      await _saveTokens(username, bodyJson['token']);
      _loggedIn = true;
    } else {
      _loggedIn = false;
    }

    return _loggedIn;
  }

  Future logout() async {
    await _saveTokens(null, null);
    _loggedIn = false;
  }

  String _getEncodedAuthorization(String username, String password) {
    final authorizationBytes = UTF8.encode('${username}:${password}');
    return BASE64.encode(authorizationBytes);
  }

  Future _saveTokens(String username, String oauthToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(KEY_USERNAME, username);
    prefs.setString(KEY_OAUTH_TOKEN, oauthToken);
    await prefs.commit();
    _username = username;
    _oauthClient = new OauthClient(_client, oauthToken);
  }
}

class OauthClient extends _AuthClient {
  OauthClient(Client client, String token) : super(client, 'token ${token}');
}

abstract class _AuthClient extends BaseClient {

  final Client _client;
  final String _authorization;

  _AuthClient(this._client, this._authorization);

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    request.headers['Authorization'] = _authorization;
    return _client.send(request);
  }
}
