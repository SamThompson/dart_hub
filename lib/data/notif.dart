import 'package:dart_hub/data/date_utils.dart';
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

  const Notif(this.id, this.repo, this.subject, this.reason, this.unread,
      this.updatedAt, this.lastReadAt, this.url);

  factory Notif.fromJson(json) {
    if (json == null) {
      return null;
    } else {
      return new Notif(
          json['id'],
          new Repo.fromJson(json['repository']),
          new NotifSubject.fromJson(json['subject']),
          json['reason'],
          json['unread'],
          dateTimeFromString(json['updated_at']),
          dateTimeFromString(json['updated_at']),
          json['url']);
    }
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

NotifSubjectType notifSubjectTypeFromString(String stringType) {
  switch (stringType) {
    case 'Issue':
      return NotifSubjectType.Issue;
      break;
    default:
      return NotifSubjectType.Unknown;
  }
}

class NotifSubject {
  final String title;
  final String url;
  final String latestCommentUrl;
  final NotifSubjectType type;

  const NotifSubject(this.title, this.url, this.latestCommentUrl, this.type);

  factory NotifSubject.fromJson(json) {
    if (json == null) {
      return null;
    } else {
      return new NotifSubject(
          json['title'],
          json['url'],
          json['latest_comment_url'],
          notifSubjectTypeFromString(json['type']));
    }
  }

  @override
  String toString() {
    return 'NotifSubject{title: $title, url: $url, latestCommentUrl: $latestCommentUrl, type: $type}';
  }

}
