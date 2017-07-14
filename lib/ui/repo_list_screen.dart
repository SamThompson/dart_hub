import 'dart:async';
import 'package:dart_hub/data/repo.dart';
import 'package:dart_hub/manager/auth_manager.dart';
import 'package:dart_hub/manager/repo_list_paginator.dart';
import 'package:dart_hub/ui/paginated_list_screen.dart';
import 'package:dart_hub/ui/paginated_list_view.dart';
import 'package:flutter/material.dart';

class RepoListScreen extends StatelessWidget {

  final RepoListPaginatorFactory _paginatorFactory;
  final String _username;

  RepoListScreen(this._paginatorFactory, this._username);

  @override
  Widget build(BuildContext context) {
    return new PaginatedListScreen(
      title: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text('${_username}'),
            new Text('Repositories', style: new TextStyle(fontSize: 12.0))
          ]
      ),
      paginatorFactory: _paginatorFactory,
      itemBuilder: _buildFollowerTile,
    );
  }

  Widget _buildFollowerTile(BuildContext context, Repo repo) {
    return new ListTile(
      title: new Text(repo.name),
      subtitle: new Text(repo.description != null ? repo.description : '',
          overflow: TextOverflow.ellipsis),
      trailing: repo.private
          ? const Icon(Icons.lock, color: Colors.grey)
          : null,
      onTap: () => Navigator.pushNamed(context, '/repos/${repo.fullName}'),
    );
  }
}
