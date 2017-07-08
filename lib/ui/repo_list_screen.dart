import 'dart:async';
import 'package:dart_hub/data/repo.dart';
import 'package:dart_hub/manager/auth_manager.dart';
import 'package:dart_hub/manager/repo_list_paginator.dart';
import 'package:dart_hub/ui/paginated_list_view.dart';
import 'package:flutter/material.dart';

class RepoListScreen extends StatefulWidget {

  final AuthManager _authManager;
  final String _userName;

  RepoListScreen(this._authManager, this._userName);

  @override
  State<StatefulWidget> createState() => new RepoListScreenState(_authManager);
}

class RepoListScreenState extends State<RepoListScreen> {

  final AuthManager _authManager;
  RepoListPaginator _paginator;

  RepoListScreenState(this._authManager);

  @override
  void initState() {
    super.initState();
    _paginator = new RepoListPaginator.reposForLoggedInUser(_authManager);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Repositories'),
        actions: [
//          new IconButton(
//              icon: const Icon(Icons.sort, color: Colors.white),
//              onPressed: _params
//          )
        ],
      ),
      body: new RefreshIndicator(
          onRefresh: _refresh,
          child: new PaginatedListView<Repo>(
            paginator: _paginator,
            itemBuilder: _buildFollowerTile,
          )
      ),
    );
  }

  Future _refresh() async {
    setState(() {
      _paginator = new RepoListPaginator.reposForLoggedInUser(_authManager);
    });
  }

  Widget _buildFollowerTile(BuildContext context, Repo repo) {
    return new ListTile(
      title: new Text(repo.name),
      subtitle: new Text(repo.description != null ? repo.description : '', overflow: TextOverflow.ellipsis),
      trailing: repo.private ? const Icon(Icons.lock, color: Colors.grey) : null,
    );
  }
}
