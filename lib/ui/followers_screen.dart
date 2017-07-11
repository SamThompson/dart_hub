import 'dart:async';
import 'package:dart_hub/data/user.dart';
import 'package:dart_hub/manager/auth_manager.dart';
import 'package:dart_hub/manager/followers_paginator.dart';
import 'package:dart_hub/ui/paginated_list_view.dart';
import 'package:flutter/material.dart';

class FollowersScreen extends StatefulWidget {

  final FollowersPaginatorFactory _paginatorFactory;
  final String _username;

  FollowersScreen(this._paginatorFactory, this._username);

  @override
  State<StatefulWidget> createState() => new FollowersScreenState(_paginatorFactory, _username);
}

class FollowersScreenState extends State<FollowersScreen> {

  final FollowersPaginatorFactory _paginatorFactory;
  final String _username;

  FollowersPaginator _paginator;

  FollowersScreenState(this._paginatorFactory, this._username);

  @override
  void initState() {
    super.initState();
    _paginator = _paginatorFactory.buildPaginatorForUser(_username);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text('${_username}'),
            new Text('Followers', style: new TextStyle(fontSize: 12.0))
          ]
      ),
      ),
      body: new RefreshIndicator(
          onRefresh: _refresh,
          child: new PaginatedListView<User>(
            paginator: _paginator,
            itemBuilder: _buildFollowerTile,
          )
      ),
    );
  }

  Future _refresh() async {
    setState(() {
      _paginator = _paginatorFactory.buildPaginatorForUser(_username);
    });
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
