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

  final StreamController<Bookmark> _nextPageRequests = new StreamController<Bookmark>();

  Stream<_State<T>> get stateStream => _stateStream;

  Stream<_State<T>> _stateStream;

  Paginator() {
    _stateStream = _buildStateStream(_nextPageRequests);
  }

  Future<Page<T>> loadPage(Bookmark bookmark);

  void loadNextPage(Bookmark bookmark) {
    _nextPageRequests.add(bookmark);
  }

  Stream<_State<T>> _buildStateStream<T>(StreamController<Bookmark> controller) {
    return StreamExt.scan(
        controller.stream
            .distinct((Bookmark item1, Bookmark item2) => item1 == item2)
            .asyncMap((Bookmark bookmark) => loadPage(bookmark)),
        new _State(null, null),
        _accumulate
    );
  }

  _State<T> _accumulate<T>(_State<T> prevState, Page<T> newPage) {
    var newItems;
    if (prevState.items != null) {
      prevState.items.addAll(newPage.items);
      newItems = prevState.items;
    } else {
      newItems = newPage.items;
    }

    return new _State<T>(newItems, newPage.bookmark);
  }
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

class PaginatedListView<T> extends StatelessWidget {

  final Paginator<T> _paginator;
  final ItemBuilder<T> _itemBuilder;
  final LoadingViewBuilder _loadingViewBuilder;
  final EmptyViewBuilder _emptyViewBuilder;
  final ErrorViewBuilder _errorViewBuilder;
  final LoadingBumperBuilder _loadingBumperBuilder;

  const PaginatedListView({
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
    return new StreamBuilder<_State<T>>(
        stream: _paginator.stateStream,
        builder: (BuildContext context, AsyncSnapshot<_State<T>> snapshot) {
          if (snapshot.hasError) {
            return _errorViewBuilder(context, snapshot.error);
          }

          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return _loadingViewBuilder(context);
            case ConnectionState.waiting:
              _paginator.loadNextPage(new Bookmark(new Map()));
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
            _paginator.loadNextPage(state.nextBookmark);
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
    return _buildMessageView(error.toString());
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
