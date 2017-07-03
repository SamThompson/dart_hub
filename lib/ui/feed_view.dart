import 'dart:async';
import 'package:dart_hub/data/event.dart';
import 'package:dart_hub/manager/feed_manager.dart';
import 'package:dart_hub/ui/paginated_list_view.dart';
import 'package:flutter/material.dart';

class FeedView extends StatefulWidget {

  final EventsManager _feedManager;

  FeedView(this._feedManager);

  @override
  State<StatefulWidget> createState() => new FeedViewState(_feedManager);
}

class FeedViewState extends State<FeedView> {

  final EventsManager _feedManager;
  FeedPaginator _paginator;

  FeedViewState(this._feedManager);

  @override
  void initState() {
    super.initState();
    _paginator = new FeedPaginator(_feedManager);
  }

  Future _refresh() async {
    print('refresh');
//    setState(() {
//      _paginator = new FeedPaginator(_feedManager);
//    });
  }

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
        onRefresh: _refresh,
        child: new PaginatedListViewBuilder<Event>(
          paginator: _paginator,
          itemBuilder: _buildEventTile,
        )
    );
  }

  Widget _buildEventTile(BuildContext context, Event event) {
    var icon;
    var title;
    switch (event.type) {
      case EventType.CreateEvent:
        icon = Icons.add;
        title = '${event.actor.login} created repository ${event.repo.name}';
        break;
      case EventType.ForkEvent:
        icon = Icons.call_split;
        title = '${event.actor.login} forked ${event.repo.name}';
        break;
      case EventType.MemberEvent:
        icon = Icons.person;
        title = 'Member event';
        break;
      case EventType.WatchEvent:
        icon = Icons.star;
        title = '${event.actor.login} starred ${event.repo.name}';
        break;
      default:
        icon = Icons.info;
        title = 'Unknown event with id ${event.id}';
    }

    return new ListTile(
        leading: new Icon(icon),
        title: new Text(title, style: new TextStyle(fontSize: 14.0))
    );
  }
}

class FeedPaginator extends Paginator<Event> {

  final EventsManager _feedManager;

  FeedPaginator(this._feedManager);

  @override
  Future<Page<Event>> loadPage(Bookmark bookmark) {
    return _feedManager.loadEvents().then((List<Event> events) => new Page(null, events));
  }
}