import 'package:dart_hub/manager/auth_manager.dart';
import 'package:dart_hub/manager/profile_manager.dart';
import 'package:dart_hub/ui/events_view.dart';
import 'package:dart_hub/ui/notif_view.dart';
import 'package:dart_hub/ui/profile_view.dart';
import 'package:dart_hub/ui/search_view.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {

  final AuthManager _authManager;

  HomeScreen(this._authManager);

  @override
  State createState() => new HomeScreenState(_authManager);
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {

  final AuthManager _authManager;
  int _currentIndex = 0;
  List<HomeScreenItem> _homeScreenItems;

  HomeScreenState(this._authManager);

  @override
  void initState() {
    super.initState();
    _homeScreenItems = [
      new HomeScreenItem(
        icon: const Icon(Icons.rss_feed),
        title: const Text('Feed'),
        content: new EventsView(_authManager),
      ),
      new HomeScreenItem(
        icon: const Icon(Icons.search),
        title: const Text('Search'),
        content: new SearchView(),
      ),
      new HomeScreenItem(
          icon: const Icon(Icons.notifications),
          title: const Text('Alerts'),
          content: new NotifView(_authManager)
      ),
      new HomeScreenItem(
        icon: const Icon(Icons.person),
        title: const Text('Profile'),
        content: new ProfileView(_authManager, new ProfileManager(_authManager)),
      )
    ];
  }

  void _navBarItemSelected(int selected) {
    setState(() {
      _currentIndex = selected;
    });
  }

  void _overflow(OverflowItem selected) {
    switch (selected) {
      case OverflowItem.Settings:
        break;
      case OverflowItem.LogOut:
        _authManager.logout()
            .then((_) => Navigator.pushReplacementNamed(context, '/login'));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('DartHub'),
        actions: [
          new PopupMenuButton<OverflowItem>(
              onSelected: _overflow,
              itemBuilder: (BuildContext context) {
                return [
//                  new PopupMenuItem(value: OverflowItem.Settings,
//                      child: new Text('Settings')),
                  new PopupMenuItem<OverflowItem>(
                      value: OverflowItem.LogOut, child: new Text('Log out'))
                ];
              })
        ],
      ),
      body: _homeScreenItems[_currentIndex].content,
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: _currentIndex,
        items: _homeScreenItems.map((HomeScreenItem item) => item.item)
            .toList(),
        onTap: _navBarItemSelected,
      ),
    );
  }
}

enum OverflowItem {
  Settings,
  LogOut
}

class HomeScreenItem {

  final BottomNavigationBarItem item;
  final Widget content;

  HomeScreenItem({Widget icon, Widget title, Widget content})
      : item = new BottomNavigationBarItem(icon: icon, title: title),
        content = content;
}
