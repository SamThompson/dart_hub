class Event {

  final String id;
  final EventType type;
  final EventActor actor;
  final EventActor org;
  final EventRepo repo;

  Event(this.id, this.type, this.actor, this.org, this.repo);

  factory Event.fromJson(json) {
    var type;
    switch (json['type']) {
      case 'CreateEvent':
        type = EventType.CreateEvent;
        break;
      case "ForkEvent":
        type = EventType.ForkEvent;
        break;
      case 'MemberEvent':
        type = EventType.MemberEvent;
        break;
      case "WatchEvent":
        type = EventType.WatchEvent;
        break;
      default:
        type = EventType.Unknown;
    }

    var actor;
    if (json['actor'] != null) {
      actor = new EventActor.fromJson(json['actor']);
    }

    var org;
    if (json['org'] != null) {
      org = new EventActor.fromJson(json['org']);
    }

    var repo;
    if (json['repo'] != null) {
      repo = new EventRepo.fromJson(json['repo']);
    }

    return new Event(json['id'], type, actor, org, repo);
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

class EventActor {
  final int id;
  final String name;
  final String login;
  final String avatarUrl;

  EventActor(this.id, this.name, this.login, this.avatarUrl);

  factory EventActor.fromJson(json) {
    return new EventActor(json['id'], json['name'], json['login'], json['avatar_url']);
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

  EventRepo(this.id, this.name, this.url);

  factory EventRepo.fromJson(json) {
    return new EventRepo(json['id'], json['name'], json['url']);
  }

  @override
  String toString() {
    return 'EventRepo{id: $id, name: $name, url: $url}';
  }
}
