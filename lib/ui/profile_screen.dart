import 'package:dart_hub/interactor/manager/profile_manager.dart';
import 'package:dart_hub/interactor/paginator/event_paginator.dart';
import 'package:dart_hub/ui/profile_view.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {

  final ProfileManager _profileManager;
  final PerformedEventsPaginatorFactory _paginatorFctory;
  final String _username;

  ProfileScreen(this._profileManager, this._paginatorFctory, this._username);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(),
      body: new ProfileView(_profileManager, _paginatorFctory, _username),
    );
  }
}
