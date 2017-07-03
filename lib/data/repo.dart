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

  const Repo(this.id, this.owner, this.name, this.fullName, this.description,
      this.private, this.fork, this.url);

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
          json['url']
      );
    }
  }

  @override
  String toString() {
    return 'Repo{id: $id, owner: $owner, name: $name, fullName: $fullName, description: $description, private: $private, fork: $fork, url: $url}';
  }
}
