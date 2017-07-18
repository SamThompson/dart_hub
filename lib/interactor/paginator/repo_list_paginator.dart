import 'package:dart_hub/model/repo.dart';
import 'package:dart_hub/interactor/manager/auth_manager.dart';
import 'package:dart_hub/interactor/paginator/base_paginator.dart';
import 'package:dart_hub/interactor/paginator/paginator_factory.dart';
import 'package:dart_hub/ui/paginated_list/paginated_list_view.dart';

class RepoListPaginator extends BasePaginator<Repo> {

  RepoListPaginator(AuthManager authManager, String url)
      : super(authManager, url);

  RepoListPaginator.reposForUsername(AuthManager authManager,
      String username, [String sort = 'pushed'])
      : this(authManager, 'https://api.github.com/users/${username}/repos?sort=${sort}');

  RepoListPaginator.forks(AuthManager authManager, String username, String repo)
      : this(authManager, 'https://api.github.com/repos/${username}/${repo}/forks');

  @override
  Repo parseItem(itemJson) {
    return new Repo.fromJson(itemJson);
  }
}

class RepoListPaginatorFactory extends PaginatorFactory<Repo> {

  final AuthManager _authManager;
  final String _username;

  RepoListPaginatorFactory(this._authManager, this._username);

  @override
  RepoListPaginator buildPaginator() {
    return new RepoListPaginator.reposForUsername(_authManager, _username);
  }
}

class ForksPaginatorFactory extends PaginatorFactory<Repo> {
  final AuthManager _authManager;
  final String _username;
  final String _repo;

  ForksPaginatorFactory(this._authManager, this._username, this._repo);


  @override
  Paginator<Repo> buildPaginator() {
    return new RepoListPaginator.forks(_authManager, _username, _repo);
  }
}
