import 'dart:async';
import 'package:dart_hub/data/event.dart';
import 'package:dart_hub/manager/auth_manager.dart';
import 'package:dart_hub/manager/event_paginator.dart';
import 'package:dart_hub/ui/event_tile.dart';
import 'package:dart_hub/ui/paginated_list_view.dart';
import 'package:flutter/material.dart';

class EventsView extends StatefulWidget {

  final AuthManager _authManager;

  EventsView(this._authManager);

  @override
  State<StatefulWidget> createState() => new FeedViewState(_authManager);
}

class FeedViewState extends State<EventsView> {

  final AuthManager _authManager;
  EventsPaginator _paginator;

  FeedViewState(this._authManager);

  @override
  void initState() {
    super.initState();
    _paginator = new EventsPaginator.receivedEvents(_authManager, _authManager.username);
  }

  Future _refresh() async {
    setState(() {
      _paginator = new EventsPaginator.receivedEvents(_authManager, _authManager.username);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
        onRefresh: _refresh,
        child: new PaginatedListView<Event>(
          paginator: _paginator,
          itemBuilder: (BuildContext context, Event event) => new EventTile(event)
        )
    );
  }
}