import 'package:dart_hub/data/event.dart';
import 'package:dart_hub/manager/auth_manager.dart';
import 'package:dart_hub/manager/base_paginator.dart';

class EventsPaginator extends BasePaginator<Event> {

  EventsPaginator(AuthManager authManager, String baseUrl)
      : super(authManager, baseUrl);

  EventsPaginator.receivedEvents(AuthManager authManager, String username)
      : this(
      authManager, 'https://api.github.com/users/${username}/received_events');

  EventsPaginator.performedEvents(AuthManager authManager, String username)
      : this(authManager, 'https://api.github.com/users/${username}/events');

  @override
  Event parseItem(itemJson) {
    return new Event.fromJson(itemJson);
  }
}
