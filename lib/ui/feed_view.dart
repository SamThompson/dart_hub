import 'dart:async';
import 'package:dart_hub/data/event.dart';
import 'package:dart_hub/manager/feed_manager.dart';
import 'package:flutter/material.dart';

class FeedView extends StatefulWidget {

  final EventsManager _feedManager;

  FeedView(this._feedManager);

  @override
  State<StatefulWidget> createState() => new FeedViewState(_feedManager);
}

class FeedViewState extends State<FeedView> {

  final EventsManager _feedManager;
  List<Event> _items = [];

  FeedViewState(this._feedManager);

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future _init() async {
    await _load();
  }

  Future _load() async {
    try {
      List<Event> items = await _feedManager.loadEvents();
      setState(() {
        _items.addAll(items);
      });
    } catch (exception) {
      print(exception);
    }
  }

  Future _refresh() async {
    setState(() {
      _items = [];
    });

    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
        onRefresh: _refresh,
        child: new ListView.builder(
            itemCount: _items.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildEventTile(_items[index]);
            }
        )
    );
  }

  Widget _buildEventTile(Event event) {
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