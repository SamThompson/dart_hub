import 'dart:async';
import 'dart:convert';
import 'package:dart_hub/data/event.dart';
import 'package:dart_hub/manager/auth_manager.dart';

class EventsManager {

  final AuthManager _authManager;

  EventsManager(this._authManager);

  Future<List<Event>> loadEvents() async {
    var oauthClient = _authManager.oauthClient;
    var response = await oauthClient
        .get(
        'https://api.github.com/users/${_authManager.username}/received_events')
        .whenComplete(oauthClient.close);

    if (response.statusCode == 200) {
      return JSON.decode(response.body)
          .map((eventJson) => new Event.fromJson(eventJson))
          .toList();
    } else {
      throw new Exception('Error loading events');
    }
  }
}