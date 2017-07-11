import 'package:dart_hub/data/user.dart';

class Repo {
  final int id;
  final User owner;
  final String name;
  final String fullName;
  final String description;
  final bool private;
  final bool fork;
  final String url;
  final int stargazersCount;
  final int forksCount;
  final int watchersCount;
  final Repo parent;
  final int openIssues;

  const Repo(this.id, this.owner, this.name, this.fullName, this.description,
      this.private, this.fork, this.url, this.stargazersCount, this.forksCount,
      this.watchersCount, this.parent, this.openIssues);

  factory Repo.fromJson(json) {
    if (json == null) {
      return null;
    } else {
      return new Repo(
          json['id'],
          new User.fromJson(json['owner']),
          json['name'],
          json['full_name'],
          json['description'],
          json['private'],
          json['fork'],
          json['url'],
          json['stargazers_count'],
          json['forks_count'],
          json['subscribers_count'],
          new Repo.fromJson(json['parent']),
          json['open_issues']
      );
    }
  }

  @override
  String toString() {
    return 'Repo{id: $id, owner: $owner, name: $name, fullName: $fullName, description: $description, private: $private, fork: $fork, url: $url}';
  }
}
