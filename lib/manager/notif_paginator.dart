import 'package:dart_hub/data/notif.dart';
import 'package:dart_hub/manager/auth_manager.dart';
import 'package:dart_hub/manager/base_paginator.dart';

class NotifPaginator extends BasePaginator<Notif> {

  NotifPaginator(AuthManager authManager)
      : super(authManager, 'https://api.github.com/notifications');

  @override
  Notif parseItem(itemJson) {
    return new Notif.fromJson(itemJson);
  }
}

class NotifPaginatorFactory {
  final AuthManager _authManager;

  NotifPaginatorFactory(this._authManager);

  NotifPaginator buildNotifPaginator() {
    return new NotifPaginator(_authManager);
  }
}
