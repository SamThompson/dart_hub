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

  EventsPaginator.repoEvents(AuthManager authManager, String username, String repo)
      : this(authManager, 'https://api.github.com/repos/${username}/${repo}/events');

  @override
  Event parseItem(itemJson) {
    return new Event.fromJson(itemJson);
  }
}

class EventsPaginatorFactory {
  final AuthManager _authManager;

  EventsPaginatorFactory(this._authManager);

  EventsPaginator buildPaginatorForReceivedEvents(String username) {
    return new EventsPaginator.receivedEvents(_authManager, username);
  }

  EventsPaginator buildPaginatorForPerformedEvents(String username) {
    return new EventsPaginator.performedEvents(_authManager, username);
  }

  EventsPaginator buildPaginatorForRepoEvents(String username, String repo) {
    return new EventsPaginator.repoEvents(_authManager, username, repo);
  }
}
