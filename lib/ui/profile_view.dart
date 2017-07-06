import 'dart:async';
import 'package:dart_hub/data/user.dart';
import 'package:dart_hub/manager/profile_manager.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {

  final ProfileManager _profileManager;

  ProfileView(this._profileManager);

  @override
  State<StatefulWidget> createState() => new ProfileViewState(_profileManager);
}

class ProfileViewState extends State<ProfileView> {

  final ProfileManager _profileManager;
  User _user;

  ProfileViewState(this._profileManager);


  @override
  void initState() {
    super.initState();
    _load();
  }

  Future _load() async {
    var user = await _profileManager.loadUser();
    setState(() {
      _user = user;
    });
  }

  Future _refresh() async {
    _load();
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return new Center(
          child: new CircularProgressIndicator()
      );
    } else {
      return _buildProfileView();
    }
  }

  Widget _buildProfileView() {
    return new RefreshIndicator(
        onRefresh: _refresh,
        child: new Container(
          margin: new EdgeInsets.only(top: 16.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildUserIdentity(),
              new Padding(
                child: _buildUserInfo(),
                padding: new EdgeInsets.only(top: 24.0, bottom: 8.0),
              ),
              new Divider()
            ],
          ),
        )
    );
  }

  Widget _buildUserIdentity() {
    return new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Padding(
            child: new CircleAvatar(
              radius: 40.0,
              backgroundColor: Colors.grey,
              backgroundImage: new NetworkImage(_user.avatarUrl),
            ),
            padding: new EdgeInsets.only(right: 16.0),
          ),
          new Column(
            children: <Widget>[
              new Text(_user.name != null ? _user.name : ''),
              new Text(_user.login != null ? _user.login : '')
            ],
          )
        ]
    );
  }

  Widget _buildUserInfo() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.pushNamed(context, '/repos');
          },
          child: new Column(
            children: <Widget>[
              new Text(_user.publicRepos.toString()),
              new Text('Repositories')
            ],
          ),
        ),
        new FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, '/followers');
            },
            child: new Column(
              children: <Widget>[
                new Text(_user.followers.toString()),
                new Text('Followers')
              ],
            )
        ),
        new FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, '/following');
            },
            child: new Column(
              children: <Widget>[
                new Text(_user.following.toString()),
                new Text('Following')
              ],
            )
        ),
      ],
    );
  }
}
