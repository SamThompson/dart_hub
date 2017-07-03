import 'package:dart_hub/data/user.dart';
import 'package:dart_hub/manager/auth_manager.dart';
import 'package:dart_hub/manager/base_paginator.dart';

class FollowingPaginator extends BasePaginator<User> {
  FollowingPaginator(AuthManager authManager, String baseUrl)
      : super(authManager, baseUrl);

  FollowingPaginator.followingForLoggedInUser(AuthManager authManager)
      : this(authManager, 'https://api.github.com/user/following');

  FollowingPaginator.followingForUsername(AuthManager authManager,
      String username)
      : this(authManager, 'https://api.github.com/users/${username}/following');

  @override
  User parseItem(itemJson) {
    return new User.fromJson(itemJson);
  }
}