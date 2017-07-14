import 'package:dart_hub/data/user.dart';
import 'package:dart_hub/manager/following_paginator.dart';
import 'package:dart_hub/ui/paginated_list_screen.dart';
import 'package:flutter/material.dart';

class FollowingScreen extends StatelessWidget {

  final FollowingPaginatorFactory _paginatorFactory;
  final String _username;

  FollowingScreen(this._paginatorFactory, this._username);

  @override
  Widget build(BuildContext context) {
    return new PaginatedListScreen<User>(
      title: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text(_username),
            new Text('Following', style: new TextStyle(fontSize: 12.0))
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
