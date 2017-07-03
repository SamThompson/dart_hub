import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:stream_ext/stream_ext.dart';

typedef Widget LoadingViewBuilder(BuildContext context);
typedef Widget EmptyViewBuilder(BuildContext context);
typedef Widget ErrorViewBuilder(BuildContext context, Object error);
typedef Widget ItemBuilder<T>(BuildContext context, T item);
typedef Widget LoadingBumperBuilder(BuildContext context);

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

  @override
  String toString() {
    return 'Bookmark{payload: $payload}';
  }
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

  @override
  String toString() {
    return 'Page{items: $items, bookmark: $bookmark}';
  }
}

abstract class Paginator<T> {
  Future<Page<T>> loadPage(Bookmark bookmark);
}

class _State<T> {
  final List<T> items;
  final Bookmark nextBookmark;

  const _State(this.items, this.nextBookmark);

  @override
  String toString() {
    return '_State{items: $items, nextBookmark: $nextBookmark}';
  }
}

class PaginatedListViewBuilder<T> extends StatelessWidget {

  final Paginator<T> _paginator;
  final ItemBuilder<T> _itemBuilder;
  final LoadingViewBuilder _loadingViewBuilder;
  final EmptyViewBuilder _emptyViewBuilder;
  final ErrorViewBuilder _errorViewBuilder;
  final LoadingBumperBuilder _loadingBumperBuilder;

  const PaginatedListViewBuilder({
    Key key,
    @required Paginator<T> paginator,
    @required ItemBuilder<T> itemBuilder,
    LoadingViewBuilder loadingViewBuilder = _buildDefaultLoadingView,
    EmptyViewBuilder emptyViewBuilder = _buildDefaultEmptyView,
    ErrorViewBuilder errorViewBuilder = _buildDefaultErrorView,
    LoadingBumperBuilder loadingBumperBuilder = _buildDefaultLoadingBumper
  })
      : _paginator = paginator,
        _itemBuilder = itemBuilder,
        _loadingViewBuilder = loadingViewBuilder,
        _emptyViewBuilder = emptyViewBuilder,
        _errorViewBuilder = errorViewBuilder,
        _loadingBumperBuilder = loadingBumperBuilder,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    StreamController<Bookmark> controller = new StreamController();
    return new _PaginatedListView<T>(
        controller,
        _stateStream(controller),
        _itemBuilder,
        _loadingViewBuilder,
        _emptyViewBuilder,
        _errorViewBuilder,
        _loadingBumperBuilder
    );
  }

  Stream<_State<T>> _stateStream(StreamController<Bookmark> controller) {
    return StreamExt.scan(
        controller.stream
            .distinct((Bookmark item1, Bookmark item2) => item1 == item2)
            .asyncMap((Bookmark bookmark) => _paginator.loadPage(bookmark)),
        new _State(null, null),
        _accumulate
    );
  }

  _State<T> _accumulate(_State<T> prevState, Page<T> newPage) {
    var newItems;
    if (prevState.items != null) {
      prevState.items.addAll(newPage.items);
      newItems = prevState.items;
    } else {
      newItems = newPage.items;
    }

    return new _State<T>(newItems, newPage.bookmark);
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

  static Widget _buildDefaultLoadingBumper(BuildContext context) {
    return new Center(
      child: new Padding(
          padding: new EdgeInsets.symmetric(vertical: 16.0),
          child: new CircularProgressIndicator()
      ),
    );
  }
}

class _PaginatedListView<T> extends StatelessWidget {

  final StreamController<Bookmark> _controller;
  final Stream<_State<T>> _stateStream;
  final ItemBuilder<T> _itemBuilder;
  final LoadingViewBuilder _loadingViewBuilder;
  final EmptyViewBuilder _emptyViewBuilder;
  final ErrorViewBuilder _errorViewBuilder;
  final LoadingBumperBuilder _loadingBumperBuilder;

  const _PaginatedListView(this._controller, this._stateStream,
      this._itemBuilder, this._loadingViewBuilder, this._emptyViewBuilder,
      this._errorViewBuilder, this._loadingBumperBuilder);

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<_State<T>>(
        stream: _stateStream,
        builder: (BuildContext context, AsyncSnapshot<_State<T>> snapshot) {
          if (snapshot.hasError) {
            return _errorViewBuilder(context, snapshot.error);
          }

          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return _loadingViewBuilder(context);
            case ConnectionState.waiting:
              _controller.add(new Bookmark(new Map()));
              return _loadingViewBuilder(context);
            case ConnectionState.active:
            case ConnectionState.done:
              return _buildListView(context, snapshot.data);
            default:
              throw "Unknown: ${snapshot.connectionState}";
          }
        }
    );
  }

  Widget _buildListView(BuildContext context, _State<T> state) {
    var items = state.items;
    if (items.length > 0) {
      return new ListView.builder(
        itemCount: items.length + (state.nextBookmark != null ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == items.length) {
            _controller.add(state.nextBookmark);
            return _loadingBumperBuilder(context);
          } else {
            return _itemBuilder(context, items[index]);
          }
        },
      );
    } else {
      return _emptyViewBuilder(context);
    }
  }
}
