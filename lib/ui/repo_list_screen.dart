import 'dart:async';
import 'package:dart_hub/data/repo.dart';
import 'package:dart_hub/manager/auth_manager.dart';
import 'package:dart_hub/manager/repo_list_paginator.dart';
import 'package:dart_hub/ui/paginated_list_view.dart';
import 'package:flutter/material.dart';

class RepoListScreen extends StatefulWidget {

  final RepoListPaginatorFactory _paginatorFactory;
  final String _username;

  RepoListScreen(this._paginatorFactory, this._username);

  @override
  State<StatefulWidget> createState() =>
      new RepoListScreenState(_paginatorFactory, _username);
}

class RepoListScreenState extends State<RepoListScreen> {

  final RepoListPaginatorFactory _paginatorFactory;
  final String _username;
  RepoListPaginator _paginator;

  RepoListScreenState(this._paginatorFactory, this._username);

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
              new Text('Repositories', style: new TextStyle(fontSize: 12.0))
            ]
        ),
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
      _paginator = _paginatorFactory.buildPaginatorForUser(_username);
    });
  }

  Widget _buildFollowerTile(BuildContext context, Repo repo) {
    return new ListTile(
      title: new Text(repo.name),
      subtitle: new Text(repo.description != null ? repo.description : '',
          overflow: TextOverflow.ellipsis),
      trailing: repo.private
          ? const Icon(Icons.lock, color: Colors.grey)
          : null,
    );
  }
}
