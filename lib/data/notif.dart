import 'package:dart_hub/data/repo.dart';

class Notif {
  final String id;
  final Repo repo;
  final NotifSubject subject;
  final String reason;
  final bool unread;
  final DateTime updatedAt;
  final DateTime lastReadAt;
  final String url;

  Notif(this.id, this.repo, this.subject, this.reason, this.unread,
      this.updatedAt, this.lastReadAt, this.url);

  factory Notif.fromJson(json) {
    var updatedAt;
    if (json['updated_at'] != null) {
      updatedAt = DateTime.parse(json['updated_at']);
    }

    var lastReadAt;
    if (json['last_read_at'] != null) {
      lastReadAt = DateTime.parse(json['last_read_at']);
    }

    return new Notif(
        json['id'],
        new Repo.fromJson(json['repository']),
        new NotifSubject.fromJson(json['subject']),
        json['reason'],
        json['unread'],
        updatedAt,
        lastReadAt,
        json['url']);
  }

  @override
  String toString() {
    return 'Notif{id: $id, repo: $repo, subject: $subject, reason: $reason, unread: $unread, updatedAt: $updatedAt, lastReadAt: $lastReadAt, url: $url}';
  }


}

enum NotifSubjectType {
  Issue,
  Unknown
}

class NotifSubject {
  final String title;
  final String url;
  final String latestCommentUrl;
  final NotifSubjectType type;

  NotifSubject(this.title, this.url, this.latestCommentUrl, this.type);

  factory NotifSubject.fromJson(json) {
    var type;
    switch (json['type']) {
      case 'Issue':
        type = NotifSubjectType.Issue;
        break;
      default:
        type = NotifSubjectType.Unknown;
    }

    return new NotifSubject(
        json['title'], json['url'], json['latest_comment_url'], type);
  }

  @override
  String toString() {
    return 'NotifSubject{title: $title, url: $url, latestCommentUrl: $latestCommentUrl, type: $type}';
  }


}

