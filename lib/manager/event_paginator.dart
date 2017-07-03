import 'package:dart_hub/data/event.dart';
import 'package:dart_hub/manager/auth_manager.dart';
import 'package:dart_hub/manager/base_paginator.dart';

class EventsPaginator extends BasePaginator<Event> {

  EventsPaginator(AuthManager authManager) : super(authManager,
      'https://api.github.com/users/${authManager.username}/received_events');

  @override
  Event parseItem(itemJson) {
    return new Event.fromJson(itemJson);
  }
}
