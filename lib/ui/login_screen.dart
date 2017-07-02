import 'package:dart_hub/manager/auth_manager.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {

  final AuthManager _authManager;

  LoginScreen(this._authManager);

  @override
  State createState() => new LoginScreenState(_authManager);
}

class LoginScreenState extends State<LoginScreen> {

  final AuthManager _authManager;
  final _usernameController = new TextEditingController();
  final _passwordController = new TextEditingController();

  LoginScreenState(this._authManager);

  void _handleSubmit() {
    _authManager.login(_usernameController.text, _passwordController.text)
    .then((success) {
      if (success) {
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        // TODO show an error
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Login"),
        ),
        body: new Container(
            child: new Form(
              child: new Column(
                children: <Widget>[
                  new TextFormField(
                    key: new Key('username'),
                    decoration: new InputDecoration.collapsed(
                        hintText: "Username or email"),
                    autofocus: true,
                    controller: _usernameController,
                  ),
                  new TextFormField(
                    decoration: new InputDecoration.collapsed(
                        hintText: 'Password'),
                    controller: _passwordController,
                    obscureText: true,
                  ),
                  new RaisedButton(
                      child: new Text('Login'),
                      onPressed: _handleSubmit
                  )
                ],
              ),
            )
        )
    );
  }
}