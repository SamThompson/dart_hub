import 'package:flutter/material.dart';

class RepoScreen extends StatelessWidget {

  final String _username;
  final String _repo;

  RepoScreen(this._username, this._repo);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('${_username}/${_repo}'),
      ),
      body: new Center(),
    );
  }
}