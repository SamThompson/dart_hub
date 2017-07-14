import 'package:dart_hub/data/notif.dart';
import 'package:dart_hub/manager/auth_manager.dart';
import 'package:dart_hub/manager/base_paginator.dart';
import 'package:dart_hub/manager/paginator_factory.dart';

class NotifPaginator extends BasePaginator<Notif> {

  NotifPaginator(AuthManager authManager)
      : super(authManager, 'https://api.github.com/notifications');

  @override
  Notif parseItem(itemJson) {
    return new Notif.fromJson(itemJson);
  }
}

class NotifPaginatorFactory extends PaginatorFactory<Notif> {
  final AuthManager _authManager;

  NotifPaginatorFactory(this._authManager);

  @override
  NotifPaginator buildPaginator() {
    return new NotifPaginator(_authManager);
  }
}
