import 'dart:async';
import 'package:dart_hub/data/event.dart';
import 'package:dart_hub/manager/event_paginator.dart';
import 'package:dart_hub/ui/event_tile.dart';
import 'package:dart_hub/ui/paginated_list_view.dart';
import 'package:flutter/material.dart';

class EventsView extends StatefulWidget {

  final EventsPaginatorFactory _paginatorFactory;
  final String _username;

  EventsView(this._paginatorFactory, this._username);

  @override
  State<StatefulWidget> createState() =>
      new FeedViewState(_paginatorFactory, _username);
}

class FeedViewState extends State<EventsView> {

  final EventsPaginatorFactory _paginatorFactory;
  final String _username;

  EventsPaginator _paginator;

  FeedViewState(this._paginatorFactory, this._username);

  @override
  void initState() {
    super.initState();
    _paginator = _paginatorFactory.buildPaginatorForReceivedEvents(_username);
  }

  Future _refresh() async {
    setState(() {
      _paginator = _paginatorFactory.buildPaginatorForReceivedEvents(_username);
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