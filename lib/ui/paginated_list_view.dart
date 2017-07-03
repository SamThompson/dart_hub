import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:stream_ext/stream_ext.dart';

typedef Widget LoadingViewBuilder(BuildContext context);
typedef Widget EmptyViewBuilder(BuildContext context);
typedef Widget ErrorViewBuilder(BuildContext context, Object error);
typedef Widget ItemBuilder<T>(BuildContext context, T item);

class Bookmark {
  final Map<String, String> payload;

  const Bookmark(this.payload);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Bookmark &&
              runtimeType == other.runtimeType &&
              payload == other.payload;

  @override
  int get hashCode => payload.hashCode;
}

class Page<T> {
  final List<T> items;
  final Bookmark bookmark;

  const Page(this.bookmark, this.items);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Page &&
              runtimeType == other.runtimeType &&
              items == other.items &&
              bookmark == other.bookmark;

  @override
  int get hashCode =>
      items.hashCode ^
      bookmark.hashCode;
}

abstract class Paginator<T> {

  final StreamController<Bookmark> _controller = new StreamController();

  Future<Page<T>> loadPage(Bookmark bookmark);

  void _nextPage(Bookmark bookmark) {
    _controller.add(bookmark);
  }

  Stream<_State<T>> _stateStream() {
    return StreamExt.scan(
        _controller.stream
            .distinct((Bookmark item1, Bookmark item2) => item1 == item2)
            .asyncMap((Bookmark bookmark) => loadPage(bookmark)),
        new _State(null, null),
        _accumulate
    );
  }

  _State<T> _accumulate(_State<T> prevState, Page<T> newPage) {
    var newItems;
    if (prevState.items != null) {
      var newItems = new List.from(prevState.items);
      newItems.addAll(newPage.items);
    } else {
      newItems = newPage.items;
    }
    return new _State<T>(newItems, newPage.bookmark);
  }
}

class PaginatedListViewBuilder<T> extends StatelessWidget {

  final Paginator<T> _paginator;
  final ItemBuilder<T> _itemBuilder;
  final LoadingViewBuilder _loadingViewBuilder;
  final EmptyViewBuilder _emptyViewBuilder;
  final ErrorViewBuilder _errorViewBuilder;

  const PaginatedListViewBuilder({
    Key key,
    @required Paginator<T> paginator,
    @required ItemBuilder<T> itemBuilder,
    LoadingViewBuilder loadingViewBuilder = _buildDefaultLoadingView,
    EmptyViewBuilder emptyViewBuilder = _buildDefaultEmptyView,
    ErrorViewBuilder errorViewBuilder = _buildDefaultErrorView
  })
      : _paginator = paginator,
        _itemBuilder = itemBuilder,
        _loadingViewBuilder = loadingViewBuilder,
        _emptyViewBuilder = emptyViewBuilder,
        _errorViewBuilder = errorViewBuilder,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new _PaginatedListView<T>(
        _paginator,
        _itemBuilder,
        _loadingViewBuilder,
        _emptyViewBuilder,
        _errorViewBuilder
    );
  }

  static Widget _buildMessageView(String message) {
    return new Center(
        child: new Text(message)
    );
  }

  static Widget _buildDefaultLoadingView(BuildContext context) {
    return new Center(
        child: new CircularProgressIndicator()
    );
  }

  static Widget _buildDefaultEmptyView(BuildContext context) {
    return _buildMessageView('No content');
  }

  static Widget _buildDefaultErrorView(BuildContext context, Object error) {
    return _buildMessageView('An error occurred');
  }
}

class _PaginatedListView<T> extends StatelessWidget {

  final Paginator<T> _paginator;
  final ItemBuilder<T> _itemBuilder;
  final LoadingViewBuilder _loadingViewBuilder;
  final EmptyViewBuilder _emptyViewBuilder;
  final ErrorViewBuilder _errorViewBuilder;

  const _PaginatedListView(this._paginator, this._itemBuilder,
      this._loadingViewBuilder, this._emptyViewBuilder,
      this._errorViewBuilder);

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<_State<T>>(
        stream: _paginator._stateStream(),
        builder: (BuildContext context, AsyncSnapshot<_State<T>> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return _errorViewBuilder(context, snapshot.error);
          }

          print(snapshot);
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
            case ConnectionState.done:
              return _buildListView(context, snapshot.data,
                  snapshot.connectionState == ConnectionState.done);
            default:
              throw "Unknown: ${snapshot.connectionState}";
          }
        }
    );
  }

  Widget _buildListView(BuildContext context, _State<T> state, bool done) {
    if (state == null || state.items == null) {
      _paginator._nextPage(new Bookmark(null));
      return _loadingViewBuilder(context);
    }

    var items = state.items;
    if (items.length > 0) {
      return new ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          var item = items[index];
          return _itemBuilder(context, item);
        },
      );
    } else {
      return _emptyViewBuilder(context);
    }
  }
}

class _State<T> {
  final List<T> items;
  final Bookmark nextBookmark;

  const _State(this.items, this.nextBookmark);
}
