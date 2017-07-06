import 'package:dart_hub/data/repo.dart';
import 'package:dart_hub/manager/auth_manager.dart';
import 'package:dart_hub/manager/base_paginator.dart';

class RepoListPaginator extends BasePaginator<Repo> {

  RepoListPaginator(AuthManager authManager, String baseUrl, String sort)
      : super(authManager, '${baseUrl}?sort=${sort}');

  RepoListPaginator.reposForLoggedInUser(AuthManager authManager, [String sort = 'pushed'])
      : this(authManager, 'https://api.github.com/user/repos', sort);

  RepoListPaginator.reposForUsername(AuthManager authManager,
      String username, [String sort = 'pushed'])
      : this(authManager, 'https://api.github.com/users/${username}/repos', sort);

  @override
  Repo parseItem(itemJson) {
    return new Repo.fromJson(itemJson);
  }
}
