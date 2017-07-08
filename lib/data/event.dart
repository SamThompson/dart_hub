import 'package:dart_hub/data/pull_request.dart';

class Event {

  final String id;
  final EventType type;
  final EventActor actor;
  final EventActor org;
  final EventRepo repo;
  final EventPayload payload;

  const Event(this.id, this.type, this.actor, this.org, this.repo,
      this.payload);

  factory Event.fromJson(json) {
    if (json == null) {
      return null;
    } else {
      return new Event(json['id'],
          eventTypeFromString(json['type']),
          new EventActor.fromJson(json['actor']),
          new EventActor.fromJson(json['org']),
          new EventRepo.fromJson(json['repo']),
          new EventPayload.fromJson(json['payload'])
      );
    }
  }

  @override
  String toString() {
    return 'Event{id: $id, type: $type, actor: $actor, org: $org, repo: $repo}';
  }
}

enum EventType {
  CreateEvent,
  DeleteEvent,
  ForkEvent,
  PullRequestEvent,
  PushEvent,
  MemberEvent,
  WatchEvent,
  Unknown
}

EventType eventTypeFromString(String eventTypeString) {
  switch (eventTypeString) {
    case 'CreateEvent':
      return EventType.CreateEvent;
    case 'DeleteEvent':
      return EventType.DeleteEvent;
    case 'ForkEvent':
      return EventType.ForkEvent;
    case 'PushEvent':
      return EventType.PushEvent;
    case 'PullRequestEvent':
      return EventType.PullRequestEvent;
    case 'MemberEvent':
      return EventType.MemberEvent;
    case 'WatchEvent':
      return EventType.WatchEvent;
    default:
      return EventType.Unknown;
  }
}

class EventActor {
  final int id;
  final String name;
  final String login;
  final String avatarUrl;

  const EventActor(this.id, this.name, this.login, this.avatarUrl);

  factory EventActor.fromJson(json) {
    if (json == null) {
      return null;
    } else {
      return new EventActor(
          json['id'], json['name'], json['login'], json['avatar_url']);
    }
  }

  @override
  String toString() {
    return 'EventActor{id: $id, name: $name, login: $login, avatarUrl: $avatarUrl}';
  }
}

class EventRepo {
  final int id;
  final String name;
  final String url;

  const EventRepo(this.id, this.name, this.url);

  factory EventRepo.fromJson(json) {
    if (json == null) {
      return null;
    } else {
      return new EventRepo(json['id'], json['name'], json['url']);
    }
  }

  @override
  String toString() {
    return 'EventRepo{id: $id, name: $name, url: $url}';
  }
}

enum EventPayloadType {
  Branch,
  User,
  Unknown
}

EventPayloadType eventPayloadTypeFromString(String eventPayloadTypeString) {
  switch (eventPayloadTypeString) {
    case 'branch':
      return EventPayloadType.Branch;
    case 'user':
      return EventPayloadType.User;
    default:
      return EventPayloadType.Unknown;
  }
}

enum EventActionType {
  Closed,
  Opened,
  Unknown
}

EventActionType eventActionTypeFromString(String eventActionTypeString) {
  switch (eventActionTypeString) {
    case 'closed':
      return EventActionType.Closed;
    case 'opened':
      return EventActionType.Opened;
    default:
      return EventActionType.Unknown;
  }
}

class EventPayload {
  final EventActionType action;
  final String ref;
  final EventPayloadType refType;
  final EventPayloadType pusherType;
  final String description;
  final int number;
  final int size;
  final PullRequest pullRequest;

  EventPayload(this.action, this.ref, this.refType, this.pusherType,
      this.description, this.number, this.size, this.pullRequest);

  factory EventPayload.fromJson(json) {
    if (json == null) {
      return null;
    } else {
      return new EventPayload(
          eventActionTypeFromString(json['action']),
          json['ref'],
          eventPayloadTypeFromString(json['ref_type']),
          eventPayloadTypeFromString(json['pusher_type']),
          json['description'],
          json['number'],
          json['size'],
          new PullRequest.fromJson(json['pull_request'])
      );
    }
  }
}
