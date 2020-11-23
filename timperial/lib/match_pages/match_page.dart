import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timperial/config.dart';
import 'package:timperial/backend.dart';
import 'package:timperial/auth.dart';

class MatchPage extends StatefulWidget {
  MatchPage({this.toSwipePage, this.toProfilePage});

  final VoidCallback toSwipePage;
  final VoidCallback toProfilePage;
  final BaseBackend backend = Backend();

  @override
  _MatchPageState createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  QuerySnapshot matches;
  String userID;

  @override
  void initState() {
    super.initState();
    widget.backend.getOwnUserID().then((uid) {
      userID = uid;
      widget.backend.getMatches().then((querySnapshot) {
        setState(() {
          matches = querySnapshot;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.SECONDARY_COLOR,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: buildMatchCards(),
              )
            ),
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

  List<Widget> buildMatchCards() {
    List<Widget> matchCards = [];
    if(matches == null) {
      return matchCards;
    }
    matches.documents.forEach((document) {
      print(document.data["users"]);
      String matchID = document.data["users"].firstWhere((id) => id != userID);
      String matchName = document.data[matchID]["name"];
      matchCards.add(
        Card(
          child: Text(matchName),
        )
      );
    });
    return matchCards;
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
            icon: Icon(Constants.EXPLORE_PAGE_UNSELECTED_ICON, size: 27.5,),
            color: Constants.INACTIVE_COLOR_DARK,
            onPressed: () {
              print("match page pressed");
            }
          ),
          Spacer(),
          IconButton(
            icon: Icon(Constants.SWIPE_PAGE_SELECTED_ICON, size: 32.0),
            onPressed: () {
              print("go to swipe page button pressed");
              widget.toSwipePage();
            },
          ),
          Spacer(),
          IconButton(
              icon: Icon(Constants.PROFILE_PAGE_UNSELECTED_ICON, size: 27.5),
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
