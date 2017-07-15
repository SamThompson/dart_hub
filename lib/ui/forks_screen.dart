import 'package:dart_hub/data/repo.dart';
import 'package:dart_hub/manager/repo_list_paginator.dart';
import 'package:dart_hub/ui/paginated_list_screen.dart';
import 'package:dart_hub/ui/repo_tile.dart';
import 'package:flutter/material.dart';

class ForksScreen extends StatelessWidget {

  final ForksPaginatorFactory _paginatorFactory;
  final String _username;
  final String _repo;

  ForksScreen(this._paginatorFactory, this._username, this._repo);

  @override
  Widget build(BuildContext context) {
    return new PaginatedListScreen<Repo>(
      title: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text(_username),
            new Text(
                '${_repo} • Forks',
                style: const TextStyle(fontSize: 12.0)
            )
          ]
      ),
      paginatorFactory: _paginatorFactory,
      itemBuilder: _buildRepoTile,
    );
  }

  Widget _buildRepoTile(BuildContext context, Repo repo) {
    return new RepoTile(repo, fullname: true, subtitle: false);
  }
}
