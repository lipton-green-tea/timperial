import 'package:flutter/material.dart';
import 'package:timperial/config.dart';

class UnverifiedEmailPage extends StatelessWidget {
  UnverifiedEmailPage({this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Text(
                  "Looks like your email isn't verified. Please check your inbox to find an email verification link, and then try logging in again.",
                  style: Constants.TEXT_STYLE_HEADER_DARK,
                ),
                RaisedButton(
                  child: Text("Back to Login"),
                  onPressed: onLogout,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}