class Event {

  final String id;
  final EventType type;
  final EventActor actor;
  final EventActor org;
  final EventRepo repo;

  const Event(this.id, this.type, this.actor, this.org, this.repo);

  factory Event.fromJson(json) {
    if (json == null) {
      return null;
    } else {
      return new Event(json['id'],
          eventTypeFromString(json['type']),
          new EventActor.fromJson(json['actor']),
          new EventActor.fromJson(json['org']),
          new EventRepo.fromJson(json['repo'])
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
  ForkEvent,
  MemberEvent,
  WatchEvent,
  Unknown
}

EventType eventTypeFromString(String eventTypeString) {
  switch (eventTypeString) {
    case 'CreateEvent':
      return EventType.CreateEvent;
      break;
    case "ForkEvent":
      return EventType.ForkEvent;
      break;
    case 'MemberEvent':
      return EventType.MemberEvent;
      break;
    case "WatchEvent":
      return EventType.WatchEvent;
      break;
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
