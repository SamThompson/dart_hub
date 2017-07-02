import 'package:dart_hub/manager/auth_manager.dart';
import 'package:dart_hub/manager/notif_manager.dart';
import 'package:dart_hub/ui/home_screen.dart';
import 'package:dart_hub/ui/login_screen.dart';
import 'package:dart_hub/ui/notifications_screen.dart';
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
        "/": (BuildContext context) => new SplashScreen(_authManager),
        "/home": (BuildContext context) => new HomeScreen(_authManager),
        "/login": (BuildContext context) => new LoginScreen(_authManager),
        '/notifications': (BuildContext context) => new NotifScreen(new NotifManager(_authManager))
      },
    );
  }
}