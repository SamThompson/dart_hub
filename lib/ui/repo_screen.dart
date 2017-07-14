import 'dart:async';
import 'package:dart_hub/data/event.dart';
import 'package:dart_hub/data/repo.dart';
import 'package:dart_hub/manager/RepoManager.dart';
import 'package:dart_hub/manager/event_paginator.dart';
import 'package:dart_hub/ui/event_tile.dart';
import 'package:dart_hub/ui/paginated_list_view.dart';
import 'package:flutter/material.dart';

class RepoScreen extends StatefulWidget {

  final RepoManager _repoManager;
  final EventsPaginatorFactory _paginatorFactory;
  final String _username;
  final String _repo;

  RepoScreen(this._repoManager, this._paginatorFactory, this._username, this._repo);

  @override
  State<StatefulWidget> createState() =>
      new _RepoScreenState(_repoManager, _paginatorFactory, _username, _repo);
}

class _RepoScreenState extends State<RepoScreen> {

  final RepoManager _repoManager;
  final EventsPaginatorFactory _paginatorFactory;
  final String _username;
  final String _repo;

  Future<Repo> _future;
  EventsPaginator _paginator;

  _RepoScreenState(this._repoManager, this._paginatorFactory, this._username, this._repo);

  @override
  void initState() {
    super.initState();
    _future = _repoManager.loadRepo(_username, _repo);
    _paginator = _paginatorFactory.buildPaginatorForRepoEvents(_username, _repo);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Text(_username),
                new Text(_repo, style: new TextStyle(fontSize: 12.0))
              ]
          )
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return new Column(
        children: <Widget>[
          _buildRepoView(),
          new Flexible(
              child: new PaginatedListView<Event>(
                paginator: _paginator,
                itemBuilder: (BuildContext context, Event events) => new EventTile(events),
              )
          )
        ]
    );
  }

  Widget _buildRepoView() {
    return new FutureBuilder<Repo>(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<Repo> snapshot) {
          if (snapshot.hasError) {
            return new Center(
              child: new Text(snapshot.error),
            );
          }

          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return new Center(
                child: new CircularProgressIndicator(),
              );
            default:
              return new Column(
                  children: <Widget>[
                    _buildRepoHeader(snapshot.data),
                    const Divider()
                  ]
              );
          }
        }
    );
  }

  Widget _buildRepoHeader(Repo repo) {
    var items = <Widget>[];

    if (repo.fork) {
      items.add(
          new Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: new Text(
                repo.fork ? 'Forked from ${repo.parent.fullName}' : '',
                style: const TextStyle(
                    fontSize: 12.0, fontStyle: FontStyle.italic),
              )
          )
      );
    }

    if (repo.description != null) {
      items.add(
          new Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: new Text(
                repo.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              )
          )
      );
    }

    items.add(
        new Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildStatButton(repo.subscribersCount,
                    const Icon(Icons.visibility, size: 14.0)),
                _buildStatButton(
                    repo.stargazersCount, const Icon(Icons.star, size: 14.0)),
                _buildStatButton(
                    repo.forksCount, const Icon(Icons.call_split, size: 14.0))
              ],
            )
        )
    );

    items.add(
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildStatButton(repo.openIssues, const Text('Issues')),
            _buildStatButton(repo.openIssues, const Text('Pull requests'))
          ],
        )
    );

    return new Container(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: items
        )
    );
  }

  Widget _buildStatButton(int count, Widget bottom) {
    return new FlatButton(
        onPressed: () {},
        child: new Column(
          children: <Widget>[
            new Text(count.toString()),
            new Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: bottom
            )
          ],
        )
    );
  }
}
