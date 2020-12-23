import 'package:flutter/material.dart';
import '../auth.dart';
import 'package:flutter/material.dart';
import 'cards_section_alignment.dart';
import 'package:timperial/config.dart';

class SwipePage extends StatefulWidget {
  SwipePage({this.auth, this.onSignedOut, this.toMatchPage, this.toProfilePage});
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final VoidCallback toMatchPage;
  final VoidCallback toProfilePage;

  @override
  _SwipePageState createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.SECONDARY_COLOR,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CardsSectionAlignment(context, widget.auth),
            Container(
              color: Constants.OUTLINE_COLOR,
              width: double.infinity,
              height: 0.5,
            ),
            navigationBar()
          ],
        ),
      ),
    );
  }

  Widget navigationBar() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Constants.SECONDARY_COLOR,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Spacer(),
          IconButton(
            icon: Icon(Constants.EXPLORE_PAGE_UNSELECTED_ICON, color: Constants.UNSELECTED_ICON_COLOR, size: 27.5,),
            color: Constants.INACTIVE_COLOR_DARK,
            onPressed: widget.toMatchPage,
          ),
          Spacer(),
          IconButton(
            icon: Icon(Constants.SWIPE_PAGE_SELECTED_ICON, color: Constants.SELECTED_ICON_COLOR , size: 32.0),
            onPressed: (){print("home pressed");},
          ),
          Spacer(),
          IconButton(
              icon: Icon(Constants.PROFILE_PAGE_UNSELECTED_ICON, color: Constants.UNSELECTED_ICON_COLOR, size: 27.5),
              onPressed: () {
                print("go to profile page button pressed");
                widget.toProfilePage();
              }
          ),
          Spacer(),
        ],
      ),
    );
  }
}