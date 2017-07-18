import 'package:dart_hub/model/user.dart';
import 'package:dart_hub/interactor/manager/auth_manager.dart';
import 'package:dart_hub/interactor/paginator/base_paginator.dart';
import 'package:dart_hub/interactor/paginator/paginator_factory.dart';
import 'package:dart_hub/ui/paginated_list/paginated_list_view.dart';

class UserPaginator extends BasePaginator<User> {
  UserPaginator(AuthManager authManager, String baseUrl)
      : super(authManager, baseUrl);

  UserPaginator.followingForUsername(AuthManager authManager, String username)
      : this(authManager, 'https://api.github.com/users/${username}/following');

  UserPaginator.followersForUsername(AuthManager authManager, String username)
      : this(authManager, 'https://api.github.com/users/${username}/followers');

  UserPaginator.stargazers(AuthManager authManager,
      String username,
      String repo) : this(
      authManager,
      'https://api.github.com/repos/${username}/${repo}/stargazers'
  );

  UserPaginator.subscribers(AuthManager authManager,
      String username,
      String repo) : this(
      authManager,
      'https://api.github.com/repos/${username}/${repo}/stargazers'
  );

  @override
  User parseItem(itemJson) {
    return new User.fromJson(itemJson);
  }
}

class FollowingPaginatorFactory extends PaginatorFactory<User> {

  final AuthManager _authManager;
  final String _username;

  FollowingPaginatorFactory(this._authManager, this._username);

  @override
  UserPaginator buildPaginator() {
    return new UserPaginator.followingForUsername(_authManager, _username);
  }
}

class FollowersPaginatorFactory extends PaginatorFactory<User> {

  final AuthManager _authManager;
  final String _username;

  FollowersPaginatorFactory(this._authManager, this._username);

  @override
  UserPaginator buildPaginator() {
    return new UserPaginator.followersForUsername(_authManager, _username);
  }
}

class StargazersPaginatorFactory extends PaginatorFactory<User> {

  final AuthManager _authManager;
  final String _username;
  final String _repo;

  StargazersPaginatorFactory(this._authManager, this._username, this._repo);

  @override
  Paginator<User> buildPaginator() {
    return new UserPaginator.stargazers(_authManager, _username, _repo);
  }
}

class SubscribersPaginatorFactory extends PaginatorFactory<User> {

  final AuthManager _authManager;
  final String _username;
  final String _repo;

  SubscribersPaginatorFactory(this._authManager, this._username, this._repo);

  @override
  Paginator<User> buildPaginator() {
    return new UserPaginator.subscribers(_authManager, _username, _repo);
  }
}
