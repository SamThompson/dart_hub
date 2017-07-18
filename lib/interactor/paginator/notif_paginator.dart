import 'package:dart_hub/model/notif.dart';
import 'package:dart_hub/interactor/manager/auth_manager.dart';
import 'package:dart_hub/interactor/paginator/base_paginator.dart';
import 'package:dart_hub/interactor/paginator/paginator_factory.dart';

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
