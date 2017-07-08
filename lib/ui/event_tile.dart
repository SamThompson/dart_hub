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
        title = _buildCreateText(_event);
        break;
      case EventType.DeleteEvent:
        icon = Icons.close;
        title = _buildDeleteText(_event);
        break;
      case EventType.ForkEvent:
        icon = Icons.call_split;
        title = '${_event.actor.login} forked ${_event.repo.name}';
        break;
      case EventType.PullRequestEvent:
        icon =
        _event.payload.action == EventActionType.Opened
            ? Icons.add
            : Icons.close;
        title = _buildPullText(_event);
        break;
      case EventType.PushEvent:
        icon = Icons.call_merge;
        title = _buildPushText(_event);
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

  String _buildCreateText(Event event) {
    switch (event.payload.refType) {
      case EventPayloadType.Branch:
        return '${event.actor.login} created branch ${event.payload.ref}';
      default:
        return '${_event.actor.login} created repository ${_event.repo.name}';
    }
  }

  String _buildDeleteText(Event event) {
    switch (event.payload.refType) {
      case EventPayloadType.Branch:
        return '${event.actor.login} deleted branch ${event.payload.ref}';
      default:
        return 'Unknown event with id ${_event.id}';
    }
  }

  String _buildPullText(Event event) {
    switch (event.payload.action) {
      case EventActionType.Closed:
        return '${event.actor.login} '
            'closed pull request #${event.payload.pullRequest.number}: '
            '${event.payload.pullRequest.title}';
      case EventActionType.Opened:
        return '${event.actor.login} '
            'opened pull request #${event.payload.pullRequest.number}: '
            '${event.payload.pullRequest.title}';
      default:
        return 'Unknown event with id ${_event.id}';
    }
  }

  String _buildPushText(Event event) {
    return '${event.actor.login} pushed '
        '${event.payload.size} commits to ${event.repo.name}';
  }
}
