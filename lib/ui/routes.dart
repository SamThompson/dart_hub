import 'package:dart_hub/manager/auth_manager.dart';
import 'package:dart_hub/ui/followers_screen.dart';
import 'package:dart_hub/ui/following_screen.dart';
import 'package:dart_hub/ui/repo_list_screen.dart';
import 'package:dart_hub/ui/repo_screen.dart';
import 'package:dart_hub/ui/home_screen.dart';
import 'package:dart_hub/ui/login_screen.dart';
import 'package:dart_hub/ui/profile_screen.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

typedef Widget HandlerFunc(BuildContext context, Map<String, dynamic> params);

HandlerFunc buildLoginHandler(AuthManager authManager) {
  return (BuildContext context, Map<String, dynamic> params) => new LoginScreen(authManager);
}

HandlerFunc buildHomeHandler(AuthManager authManager) {
  return (BuildContext context, Map<String, dynamic> params) => new HomeScreen(authManager);
}

HandlerFunc buildUserHandler() {
  return (BuildContext context, Map<String, dynamic> params) => new ProfileScreen(params['user']);
}

HandlerFunc buildRepoListHandler(AuthManager authManager) {
  return (BuildContext context, Map<String, dynamic> params) => new RepoListScreen(authManager, params['username']);
}

HandlerFunc buildFollowersHandler(AuthManager authManager) {
  return (BuildContext context, Map<String, dynamic> params) => new FollowersScreen(authManager, params['username']);
}

HandlerFunc buildFollowingHandler(AuthManager authManager) {
  return (BuildContext context, Map<String, dynamic> params) => new FollowingScreen(authManager, params['username']);
}

HandlerFunc buildRepoHandler() {
  return (BuildContext context, Map<String, dynamic> params) => new RepoScreen(params['owner'], params['repo']);
}

void configureRouter(Router router, AuthManager authManager) {
  router.define('/login', handler: new Handler(handlerFunc: buildLoginHandler(authManager)));
  router.define('/home', handler: new Handler(handlerFunc: buildHomeHandler(authManager)));
  router.define('/user/repos', handler: new Handler(handlerFunc: buildRepoListHandler(authManager)));
  router.define('/users/:username/repos', handler: new Handler(handlerFunc: buildRepoListHandler(authManager)));
  router.define('/user/followers', handler: new Handler(handlerFunc: buildFollowersHandler(authManager)));
  router.define('/users/:username/followers', handler: new Handler(handlerFunc: buildFollowersHandler(authManager)));
  router.define('/user/following', handler: new Handler(handlerFunc: buildFollowingHandler(authManager)));
  router.define('/users/:username/following', handler: new Handler(handlerFunc: buildFollowingHandler(authManager)));
  router.define('/repos/:owner/:repo', handler: new Handler(handlerFunc: buildRepoHandler()));
}
