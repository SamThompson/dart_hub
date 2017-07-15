import 'package:dart_hub/data/repo.dart';
import 'package:dart_hub/manager/repo_list_paginator.dart';
import 'package:dart_hub/ui/paginated_list_screen.dart';
import 'package:dart_hub/ui/repo_tile.dart';
import 'package:flutter/material.dart';

class RepoListScreen extends StatelessWidget {

  final RepoListPaginatorFactory _paginatorFactory;
  final String _username;

  RepoListScreen(this._paginatorFactory, this._username);

  @override
  Widget build(BuildContext context) {
    return new PaginatedListScreen<Repo>(
      title: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text(_username),
            new Text('Repositories', style: new TextStyle(fontSize: 12.0))
          ]
      ),
      paginatorFactory: _paginatorFactory,
      itemBuilder: _buildRepoTile,
    );
  }

  Widget _buildRepoTile(BuildContext context, Repo repo) {
    return new RepoTile(repo);
  }
}
