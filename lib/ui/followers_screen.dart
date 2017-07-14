import 'package:dart_hub/data/user.dart';
import 'package:dart_hub/manager/followers_paginator.dart';
import 'package:dart_hub/ui/paginated_list_screen.dart';
import 'package:flutter/material.dart';

class FollowersScreen extends StatelessWidget {

  final FollowersPaginatorFactory _paginatorFactory;
  final String _username;

  FollowersScreen(this._paginatorFactory, this._username);

  @override
  Widget build(BuildContext context) {
    return new PaginatedListScreen(
      title: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text('${_username}'),
            new Text('Followers', style: new TextStyle(fontSize: 12.0))
          ]
      ),
      paginatorFactory: _paginatorFactory,
      itemBuilder: _buildFollowerTile,
    );
  }

  Widget _buildFollowerTile(BuildContext context, User user) {
    return new ListTile(
        leading: new CircleAvatar(
            backgroundImage: new NetworkImage(user.avatarUrl),
            backgroundColor: Colors.grey
        ),
        title: new Text(user.login),
        onTap: () => Navigator.pushNamed(context, '/users/${user.login}')
    );
  }
}
