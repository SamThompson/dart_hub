import 'package:dart_hub/model/user.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {

  final User _user;

  UserTile(this._user);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
        leading: new CircleAvatar(
            backgroundImage: new NetworkImage(_user.avatarUrl),
            backgroundColor: Colors.grey
        ),
        title: new Text(_user.login),
        onTap: () => Navigator.pushNamed(context, '/users/${_user.login}')
    );
  }
}