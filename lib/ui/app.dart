import 'package:dart_hub/manager/auth_manager.dart';
import 'package:dart_hub/ui/followers_screen.dart';
import 'package:dart_hub/ui/following_screen.dart';
import 'package:dart_hub/ui/home_screen.dart';
import 'package:dart_hub/ui/login_screen.dart';
import 'package:dart_hub/ui/notif_view.dart';
import 'package:dart_hub/ui/splash_screen.dart';
import 'package:flutter/material.dart';

class DartHubApp extends StatelessWidget {

  final AuthManager _authManager = new AuthManager();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'DartHub',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => new SplashScreen(_authManager),
        '/home': (BuildContext context) => new HomeScreen(_authManager),
        '/login': (BuildContext context) => new LoginScreen(_authManager),
        '/followers': (BuildContext context) => new FollowersScreen(_authManager),
        '/following': (BuildContext context) => new FollowingScreen(_authManager)
      },
    );
  }
}
