import 'package:dart_hub/data/repo.dart';
import 'package:flutter/material.dart';

class RepoTile extends StatelessWidget {

  final Repo _repo;
  final bool _fullname;
  final bool _subtitle;

  RepoTile(this._repo, {
    bool fullname = false,
    bool subtitle = true
  }) :
        _fullname = fullname,
        _subtitle = subtitle;

  @override
  Widget build(BuildContext context) {
    var subtitle = _subtitle ?
    new Text(
        _repo.description != null
            ? _repo.description : '',
        overflow: TextOverflow.ellipsis
    ) : null;

    var trailing = _repo.private ?
    const Icon(Icons.lock, color: Colors.grey) : null;

    return new ListTile(
      title: new Text(_fullname ? _repo.fullName : _repo.name),
      subtitle: subtitle,
      trailing: trailing,
      onTap: () => Navigator.pushNamed(context, '/repos/${_repo.fullName}'),
    );
  }
}
