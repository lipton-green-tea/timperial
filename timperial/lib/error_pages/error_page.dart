import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  ErrorPage({this.toHomePage});

  final VoidCallback toHomePage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Text("Uh oh - an error occurred"),
                RaisedButton(
                  child: Text("back to home"),
                  onPressed: toHomePage,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}