import 'package:dart_hub/data/notif.dart';
import 'package:dart_hub/manager/auth_manager.dart';
import 'package:dart_hub/manager/notif_paginator.dart';
import 'package:dart_hub/ui/paginated_list_view.dart';
import 'package:flutter/material.dart';

class NotifScreen extends StatefulWidget {

  final AuthManager _authManager;

  NotifScreen(this._authManager);

  @override
  State<StatefulWidget> createState() => new NotifScreenState(_authManager);
}

class NotifScreenState extends State<NotifScreen> {

  final AuthManager _authManager;
  NotifPaginator _paginator;
  bool _all;
  bool _participating;

  NotifScreenState(this._authManager);

  @override
  void initState() {
    super.initState();
    _paginator = new NotifPaginator(_authManager);
    _all = true;
    _participating = true;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Notifications'),
          actions: [
            new IconButton(
                icon: const Icon(Icons.sort, color: Colors.white),
                onPressed: _params),
          ],
        ),
        body: new PaginatedListViewBuilder<Notif>(
          paginator: _paginator,
          itemBuilder: _buildNotifTile,
        )
    );
  }

  void _params() {
    showModalBottomSheet(
        context: context, builder: (context) => _buildParamsView());
  }

  Widget _buildParamsView() {
    return new ListView(
      shrinkWrap: true,
      primary: false,
      children: <Widget>[
        new ListTile(
          dense: true,
          title: const Text('All'),
          trailing: new Checkbox(value: _all, onChanged: (newValue) {
            setState(() {
              _all = newValue;
            });
          }),
        ),
        new ListTile(
          dense: true,
          title: const Text('Participating'),
          trailing: new Checkbox(value: _participating, onChanged: (newValue) {
            setState(() {
              _participating = newValue;
            });
          }),
        )
      ],
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
