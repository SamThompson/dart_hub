import 'package:dart_hub/data/event.dart';
import 'package:flutter/material.dart';

class EventTile extends StatelessWidget {

  final Event _event;

  EventTile(this._event);

  @override
  Widget build(BuildContext context) {
    var icon;
    var title;
    switch (_event.type) {
      case EventType.CreateEvent:
        icon = Icons.add;
        title = '${_event.actor.login} created repository ${_event.repo.name}';
        break;
      case EventType.ForkEvent:
        icon = Icons.call_split;
        title = '${_event.actor.login} forked ${_event.repo.name}';
        break;
      case EventType.MemberEvent:
        icon = Icons.person;
        title = 'Member event';
        break;
      case EventType.WatchEvent:
        icon = Icons.star;
        title = '${_event.actor.login} starred ${_event.repo.name}';
        break;
      default:
        icon = Icons.info;
        title = 'Unknown event with id ${_event.id}';
    }

    return new ListTile(
        leading: new Icon(icon),
        title: new Text(title, style: new TextStyle(fontSize: 14.0))
    );
  }
}