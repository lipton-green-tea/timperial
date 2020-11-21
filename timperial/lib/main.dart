import 'package:flutter/material.dart';
import 'root_page.dart';
import 'auth.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        title: 'login test',
        home: RootPage(auth: Auth())
    );
  }
}