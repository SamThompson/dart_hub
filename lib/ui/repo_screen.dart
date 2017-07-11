import 'dart:async';
import 'package:dart_hub/data/repo.dart';
import 'package:dart_hub/manager/RepoManager.dart';
import 'package:flutter/material.dart';

class RepoScreen extends StatefulWidget {

  final RepoManager _repoManager;
  final String _username;
  final String _repo;

  RepoScreen(this._repoManager, this._username, this._repo);

  @override
  State<StatefulWidget> createState() =>
      new _RepoScreenState(_repoManager, _username, _repo);
}

class _RepoScreenState extends State<RepoScreen> {

  final RepoManager _repoManager;
  final String _username;
  final String _repo;

  Future<Repo> _future;

  _RepoScreenState(this._repoManager, this._username, this._repo);

  @override
  void initState() {
    super.initState();
    _future = _repoManager.loadRepo(_username, _repo);
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<Repo>(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<Repo> snapshot) {
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
            body: _buildBodyForSnapshot(snapshot),
          );
        }
    );
  }

  Widget _buildBodyForSnapshot(AsyncSnapshot<Repo> snapshot) {
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
        return _buildRepoHeader(snapshot.data);
    }
  }

  Widget _buildRepoHeader(Repo repo) {
    var items = <Widget>[];

    if (repo.fork) {
      items.add(
          new Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
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
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildStatButton(repo.subscribersCount, Icons.visibility),
            _buildStatButton(repo.stargazersCount, Icons.star),
            _buildStatButton(repo.forksCount, Icons.call_split)
          ],
        )
    );

    items.add(const Divider());

    return new Container(
        padding: new EdgeInsets.all(16.0),
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: items
        )
    );
  }

  Widget _buildStatButton(int count, IconData icon) {
    return new FlatButton(
        onPressed: () {},
        child: new Column(
          children: <Widget>[
            new Text(count.toString()),
            new Padding(
                padding: new EdgeInsets.only(top: 4.0),
                child: new Icon(icon, size: 14.0)
            )
          ],
        )
    );
  }
}
