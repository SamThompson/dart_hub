import 'dart:async';
import 'package:dart_hub/data/user.dart';
import 'package:dart_hub/manager/auth_manager.dart';
import 'package:dart_hub/manager/followers_paginator.dart';
import 'package:dart_hub/ui/paginated_list_view.dart';
import 'package:flutter/material.dart';

class FollowersScreen extends StatefulWidget {

  final AuthManager _authManager;

  FollowersScreen(this._authManager);

  @override
  State<StatefulWidget> createState() => new FollowersScreenState(_authManager);
}

class FollowersScreenState extends State<FollowersScreen> {

  final AuthManager _authManager;
  FollowersPaginator _paginator;

  FollowersScreenState(this._authManager);

  @override
  void initState() {
    super.initState();
    _paginator = new FollowersPaginator.followersForLoggedInUser(_authManager);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Followers'),
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
      new FollowersPaginator.followersForLoggedInUser(_authManager);
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