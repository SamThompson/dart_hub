import 'dart:async';
import 'package:dart_hub/data/notif.dart';
import 'package:dart_hub/manager/notif_manager.dart';
import 'package:flutter/material.dart';

class NotifScreen extends StatefulWidget {

  final NotifManager _notifManager;

  NotifScreen(this._notifManager);

  @override
  State<StatefulWidget> createState() => new NotifScreenState(_notifManager);
}

class NotifScreenState extends State<NotifScreen> {

  final NotifManager _notifManager;
  bool _all;
  bool _participating;
  Future<List<Notif>> _future;

  NotifScreenState(this._notifManager);

  @override
  void initState() {
    super.initState();
    _all = true;
    _participating = true;
    _future = _notifManager.loadNotifs();
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
        body: _buildNotifsView()
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

  Widget _buildNotifsView() {
    return new FutureBuilder<List<Notif>>(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<List<Notif>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return _buildLoadingView();
          default:
            if (snapshot.hasError) {
              return _buildMessageView('Error loading notifications');
            } else {
              return _buildListView(snapshot.data);
            }
        }
      },
    );
  }

  Widget _buildLoadingView() {
    return new Center(
        child: new CircularProgressIndicator()
    );
  }

  Widget _buildMessageView(String message) {
    return new Center(
        child: new Text(message)
    );
  }

  Widget _buildListView(List<Notif> items) {
    if (items.length > 0) {
      return new ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            var item = items[index];
            return new ListTile(
              title: new Text(
                  item.subject.title, style: new TextStyle(fontSize: 16.0),
                  overflow: TextOverflow.ellipsis, maxLines: 2),
              subtitle: new Text(item.repo.fullName),
              trailing: item.unread ? new Icon(Icons.new_releases) : null,
            );
          }
      );
    } else {
      return _buildMessageView('No notifications');
    }
  }
}