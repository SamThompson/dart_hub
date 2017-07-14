import 'dart:async';
import 'package:dart_hub/data/user.dart';
import 'package:dart_hub/manager/paginator_factory.dart';
import 'package:dart_hub/ui/paginated_list_view.dart';
import 'package:flutter/material.dart';

class PaginatedListScreen<T> extends StatefulWidget {

  final PaginatorFactory<T> _paginatorFactory;
  final ItemBuilder<T> _itemBuilder;
  final Widget _title;

  const PaginatedListScreen({
    PaginatorFactory<T> paginatorFactory,
    ItemBuilder<T> itemBuilder,
    Widget title
  })
      : _paginatorFactory = paginatorFactory,
        _itemBuilder = itemBuilder,
        _title = title;

  @override
  State<StatefulWidget> createState() =>
      new _PaginatedListScreenState(_paginatorFactory, _itemBuilder, _title);
}

class _PaginatedListScreenState<T> extends State<PaginatedListScreen> {

  final PaginatorFactory<T> _paginatorFactory;
  final ItemBuilder<T> _itemBuilder;
  final Widget _title;

  Paginator<T> _paginator;

  _PaginatedListScreenState(this._paginatorFactory, this._itemBuilder,
      this._title);

  @override
  void initState() {
    super.initState();
    _paginator = _paginatorFactory.buildPaginator();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: _title
      ),
      body: new RefreshIndicator(
          onRefresh: _refresh,
          child: new PaginatedListView<T>(
            paginator: _paginator,
            itemBuilder: _itemBuilder,
          )
      ),
    );
  }

  Future _refresh() async {
    setState(() {
      _paginator = _paginatorFactory.buildPaginator();
    });
  }

  Widget _buildFollowerTile(BuildContext context, User user) {
    return new ListTile(
        leading: new CircleAvatar(
            backgroundImage: new NetworkImage(user.avatarUrl),
            backgroundColor: Colors.grey
        ),
        title: new Text(user.login),
        onTap: () => Navigator.pushNamed(context, '/users/${user.login}')
    );
  }
}
