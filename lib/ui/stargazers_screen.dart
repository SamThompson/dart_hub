import 'package:dart_hub/data/user.dart';
import 'package:dart_hub/manager/user_paginator.dart';
import 'package:dart_hub/ui/paginated_list_screen.dart';
import 'package:dart_hub/ui/user_tile.dart';
import 'package:flutter/material.dart';

class StargazersScreen extends StatelessWidget {

  final StargazersPaginatorFactory _paginatorFactory;
  final String _username;
  final String _repo;

  StargazersScreen(this._paginatorFactory, this._username, this._repo);

  @override
  Widget build(BuildContext context) {
    return new PaginatedListScreen<User>(
      title: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text(_username),
            new Text('${_repo} • Stargazers', style: const TextStyle(fontSize: 12.0))
          ]
      ),
      paginatorFactory: _paginatorFactory,
      itemBuilder: _buildUserTile,
    );
  }

  Widget _buildUserTile(BuildContext context, User user) {
    return new UserTile(user);
  }
}