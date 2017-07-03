import 'dart:async';
import 'package:dart_hub/data/event.dart';
import 'package:dart_hub/manager/auth_manager.dart';
import 'package:dart_hub/manager/event_paginator.dart';
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
    _paginator = new EventsPaginator(_authManager);
  }

  Future _refresh() async {
    setState(() {
      _paginator = new EventsPaginator(_authManager);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
        onRefresh: _refresh,
        child: new PaginatedListViewBuilder<Event>(
          paginator: _paginator,
          itemBuilder: _buildEventTile,
        )
    );
  }

  Widget _buildEventTile(BuildContext context, Event event) {
    var icon;
    var title;
    switch (event.type) {
      case EventType.CreateEvent:
        icon = Icons.add;
        title = '${event.actor.login} created repository ${event.repo.name}';
        break;
      case EventType.ForkEvent:
        icon = Icons.call_split;
        title = '${event.actor.login} forked ${event.repo.name}';
        break;
      case EventType.MemberEvent:
        icon = Icons.person;
        title = 'Member event';
        break;
      case EventType.WatchEvent:
        icon = Icons.star;
        title = '${event.actor.login} starred ${event.repo.name}';
        break;
      default:
        icon = Icons.info;
        title = 'Unknown event with id ${event.id}';
    }

    return new ListTile(
        leading: new Icon(icon),
        title: new Text(title, style: new TextStyle(fontSize: 14.0))
    );
  }
}