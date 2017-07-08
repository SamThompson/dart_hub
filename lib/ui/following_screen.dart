import 'dart:async';
import 'package:dart_hub/data/user.dart';
import 'package:dart_hub/manager/auth_manager.dart';
import 'package:dart_hub/manager/following_paginator.dart';
import 'package:dart_hub/ui/paginated_list_view.dart';
import 'package:flutter/material.dart';

class FollowingScreen extends StatefulWidget {

  final FollowingPaginatorFactory _paginatorFactory;
  final String _username;

  FollowingScreen(this._paginatorFactory, this._username);

  @override
  State<StatefulWidget> createState() => new FollowingScreenState(_paginatorFactory, _username);
}

class FollowingScreenState extends State<FollowingScreen> {

  final FollowingPaginatorFactory _paginatorFactory;
  final String _username;

  FollowingPaginator _paginator;

  FollowingScreenState(this._paginatorFactory, this._username);

  @override
  void initState() {
    super.initState();
    _paginator = _paginatorFactory.buildPaginatorForUser(_username);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Following'),
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
    );
  }
}
