import 'package:dart_hub/model/event.dart';
import 'package:dart_hub/interactor/manager/auth_manager.dart';
import 'package:dart_hub/interactor/paginator/base_paginator.dart';
import 'package:dart_hub/interactor/paginator/paginator_factory.dart';

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

class ReceivedEventsPaginatorFactory extends PaginatorFactory<Event> {

  final AuthManager _authManager;
  final String _username;

  ReceivedEventsPaginatorFactory(this._authManager, this._username);

  @override
  EventsPaginator buildPaginator() {
    return new EventsPaginator.receivedEvents(_authManager, _username);
  }
}

class PerformedEventsPaginatorFactory extends PaginatorFactory<Event> {

  final AuthManager _authManager;
  final String _username;

  PerformedEventsPaginatorFactory(this._authManager, this._username);

  @override
  EventsPaginator buildPaginator() {
    return new EventsPaginator.performedEvents(_authManager, _username);
  }
}

class RepoEventsPaginatorFactory extends PaginatorFactory<Event> {

  final AuthManager _authManager;
  final String _username;
  final String _repo;

  RepoEventsPaginatorFactory(this._authManager, this._username, this._repo);

  @override
  EventsPaginator buildPaginator() {
    return new EventsPaginator.repoEvents(_authManager, _username, _repo);
  }
}
