import 'package:flutter/material.dart';
import 'package:timperial/auth.dart';

class SwipePage extends StatefulWidget {
  SwipePage({this.onSignedOut, this.toMatchPage, this.toProfilePage});

  final VoidCallback onSignedOut;
  final VoidCallback toMatchPage;
  final VoidCallback toProfilePage;

  @override
  _SwipePageState createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text("hello world"),
      ),
    );
  }
}
