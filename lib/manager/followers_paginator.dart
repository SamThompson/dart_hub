import 'package:dart_hub/data/user.dart';
import 'package:dart_hub/manager/auth_manager.dart';
import 'package:dart_hub/manager/base_paginator.dart';

class FollowersPaginator extends BasePaginator<User> {

  FollowersPaginator(AuthManager authManager, String baseUrl)
      : super(authManager, baseUrl);

  FollowersPaginator.followersForLoggedInUser(AuthManager authManager)
      : this(authManager, 'https://api.github.com/user/followers');

  FollowersPaginator.followersForUsername(AuthManager authManager,
      String username)
      : this(authManager, 'https://api.github.com/users/${username}/followers');

  @override
  User parseItem(itemJson) {
    return new User.fromJson(itemJson);
  }
}
