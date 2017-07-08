import 'package:dart_hub/data/notif.dart';
import 'package:dart_hub/manager/notif_paginator.dart';
import 'package:dart_hub/ui/paginated_list_view.dart';
import 'package:flutter/material.dart';

class NotifView extends StatefulWidget {

  final NotifPaginatorFactory _paginatorFactory;

  NotifView(this._paginatorFactory);

  @override
  State<StatefulWidget> createState() =>
      new NotifScreenState(_paginatorFactory);
}

class NotifScreenState extends State<NotifView> {

  final NotifPaginatorFactory _paginatorFactory;
  NotifPaginator _paginator;

  NotifScreenState(this._paginatorFactory);

  @override
  void initState() {
    super.initState();
    _paginator = _paginatorFactory.buildNotifPaginator();
  }

  @override
  Widget build(BuildContext context) {
    return new PaginatedListView<Notif>(
      paginator: _paginator,
      itemBuilder: _buildNotifTile,
      emptyViewBuilder: _buildEmptyView
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

  Widget _buildEmptyView(BuildContext context) {
    return new Center(
        child: new Text('No notifications')
    );
  }
}
