import 'dart:async';
import 'package:dart_hub/data/user.dart';
import 'package:dart_hub/manager/auth_manager.dart';
import 'package:dart_hub/manager/following_paginator.dart';
import 'package:dart_hub/ui/paginated_list_view.dart';
import 'package:flutter/material.dart';

class FollowingScreen extends StatefulWidget {

  final AuthManager _authManager;
  final String _username;

  FollowingScreen(this._authManager, this._username);

  @override
  State<StatefulWidget> createState() => new FollowingScreenState(_authManager);
}

class FollowingScreenState extends State<FollowingScreen> {

  final AuthManager _authManager;
  FollowingPaginator _paginator;

  FollowingScreenState(this._authManager);

  @override
  void initState() {
    super.initState();
    _paginator = new FollowingPaginator.followingForLoggedInUser(_authManager);
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
      _paginator =
      new FollowingPaginator.followingForLoggedInUser(_authManager);
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
