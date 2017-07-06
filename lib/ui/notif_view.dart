import 'package:dart_hub/data/notif.dart';
import 'package:dart_hub/manager/auth_manager.dart';
import 'package:dart_hub/manager/notif_paginator.dart';
import 'package:dart_hub/ui/paginated_list_view.dart';
import 'package:flutter/material.dart';

class NotifView extends StatefulWidget {

  final AuthManager _authManager;

  NotifView(this._authManager);

  @override
  State<StatefulWidget> createState() => new NotifScreenState(_authManager);
}

class NotifScreenState extends State<NotifView> {

  final AuthManager _authManager;
  NotifPaginator _paginator;

  NotifScreenState(this._authManager);

  @override
  void initState() {
    super.initState();
    _paginator = new NotifPaginator(_authManager);
  }

  @override
  Widget build(BuildContext context) {
    return new PaginatedListView<Notif>(
      paginator: _paginator,
      itemBuilder: _buildNotifTile,
    );
  }

  Widget _buildNotifTile(BuildContext context, Notif item) {
    return new ListTile(
      title: new Text(
          item.subject.title, style: new TextStyle(fontSize: 16.0),
          overflow: TextOverflow.ellipsis, maxLines: 2),
      subtitle: new Text(item.repo.fullName),
      trailing: item.unread ? new Icon(Icons.new_releases) : null,
    );
  }
}
