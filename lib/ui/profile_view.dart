import 'package:dart_hub/data/event.dart';
import 'package:dart_hub/data/user.dart';
import 'package:dart_hub/manager/event_paginator.dart';
import 'package:dart_hub/manager/profile_manager.dart';
import 'package:dart_hub/ui/event_tile.dart';
import 'package:dart_hub/ui/paginated_list_view.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {

  final ProfileManager _profileManager;
  final EventsPaginatorFactory _paginatorFactory;
  final String _username;

  ProfileView(this._profileManager, this._paginatorFactory, this._username);

  @override
  State<StatefulWidget> createState() =>
      new ProfileViewState(_profileManager, _paginatorFactory, _username);
}

class ProfileViewState extends State<ProfileView> {

  final ProfileManager _profileManager;
  final EventsPaginatorFactory _paginatorFactory;
  final String _username;

  EventsPaginator _paginator;

  ProfileViewState(this._profileManager,
      this._paginatorFactory,
      this._username);

  @override
  void initState() {
    super.initState();
    _paginator = _paginatorFactory.buildPaginatorForPerformedEvents(_username);
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
        children: <Widget>[
          _buildProfileView(),
          new Flexible(
              child: new PaginatedListView<Event>(
                paginator: _paginator,
                itemBuilder: (BuildContext context, Event events) => new EventTile(events),
              )
          )
        ]
    );
  }

  Widget _buildProfileView() {
    return new FutureBuilder<User>(
      future: _profileManager.loadUser(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          default:
            return _buildProfileHeader(snapshot.data);
        }
      },
    );
  }

  Widget _buildProfileHeader(User user) {
    user = user != null ? user : new User(
        -1,
        null,
        null,
        null,
        0,
        0,
        0);

    return new Container(
      margin: new EdgeInsets.only(top: 16.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildUserIdentity(user),
          new Padding(
            child: _buildUserInfo(user),
            padding: new EdgeInsets.only(top: 24.0, bottom: 8.0),
          ),
          new Divider()
        ],
      ),
    );
  }

  Widget _buildUserIdentity(User user) {
    return new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Padding(
            child: new CircleAvatar(
              radius: 40.0,
              backgroundColor: Colors.grey,
              backgroundImage: user.avatarUrl != null ? new NetworkImage(
                  user.avatarUrl) : null,
            ),
            padding: const EdgeInsets.only(right: 16.0),
          ),
          new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: new Text(
                    user.name != null ? user.name : '',
                    style: new TextStyle(fontWeight: FontWeight.bold)
                ),
              ),
              new Text(user.login != null ? user.login : '')
            ],
          )
        ]
    );
  }

  Widget _buildUserInfo(User user) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.pushNamed(context, '/user/repos');
          },
          child: new Column(
            children: <Widget>[
              new Text(user.publicRepos.toString()),
              const Text('Repositories')
            ],
          ),
        ),
        new FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, '/user/followers');
            },
            child: new Column(
              children: <Widget>[
                new Text(user.followers.toString()),
                const Text('Followers')
              ],
            )
        ),
        new FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, '/user/following');
            },
            child: new Column(
              children: <Widget>[
                new Text(user.following.toString()),
                const Text('Following')
              ],
            )
        ),
      ],
    );
  }
}
