import 'package:dart_hub/interactor/manager/auth_manager.dart';
import 'package:dart_hub/ui/routes.dart';
import 'package:dart_hub/ui/splash_screen.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class DartHubApp extends StatelessWidget {

  final Router router = new Router();
  final AuthManager _authManager = new AuthManager();

  DartHubApp() {
    configureRouter(router, _authManager);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'DartHub',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SplashScreen(_authManager),
      onGenerateRoute: router.generator,
    );
  }
}


