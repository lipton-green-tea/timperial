import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timperial/backend.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:timperial/config.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileCardAlignment extends StatefulWidget {
  ProfileCardAlignment({this.profile,Key key}) : super(key: key);

  final DocumentSnapshot profile;
  final BaseBackend backend = new Backend();

  @override
  _ProfileCardAlignmentState createState() => _ProfileCardAlignmentState();
}

enum CardSide {
  meme,
  comments
}

class _ProfileCardAlignmentState extends State<ProfileCardAlignment> {

  final formKey = new GlobalKey<FormState>();
  CardSide _cardSide = CardSide.meme;
  int maxImageSize = 8*1024*1024;
  //Widget displayImage;
  //List<CommentCard> commentCards = [];
  BaseBackend backend = new Backend();
  bool reported = false;
  List<Widget> profilePages = [];
  int tapCounter = 0;

  @override
  void initState() {
    super.initState();
    debugPrint("init card for profile " + widget.profile.documentID);
    debugPrint(widget.profile.data["profile_pages"].length.toString());
    addProfilePages();
    addBioPage();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
        ),
        clipBehavior: Clip.antiAlias,
        child: GestureDetector(
            onTap: () {
              setState(() {
                tapCounter++;
              });
            },
            child: BuildCard())
    );
  }

  void addProfilePages() {
    List<dynamic> profileImages = widget.profile.data["profile_pages"];
    profileImages.forEach((page) {
      profilePages.add(
        Stack(
          overflow: Overflow.clip,
          children: <Widget>[
            Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: AspectRatio(
                    aspectRatio: 0.9,
                    child: Material(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(page['image_url']),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    height: 80,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('${widget.profile.data["name"]}',
                            style: Constants.TEXT_STYLE_CAPTION_DARK
                        ),
                        FlatButton(
                          child: Text(
                              reported?'Reported':'Report',
                              style: Constants.FLAT_RED_BUTTON_STYLE
                          ),
                          onPressed: () {
                            if(reported) {
                              Fluttertoast.showToast(msg: "already reported");
                            } else {
                              setState(() {
                                reported = true;
                              });
                              widget.backend.report(widget.profile.documentID);
                              Fluttertoast.showToast(msg: "reported user");
                            }
                          },
                        ),
                      ],
                    ),
                    color: Constants.BACKGROUND_COLOR,
                  ),
                ),
              ],
            )
          ],
        )
      );
    });
  }

  void addBioPage() {
    profilePages.add(
      Stack(
        overflow: Overflow.clip,
        children: <Widget>[
          Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: AspectRatio(
                  aspectRatio: 0.9,
                  child: Material(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                      child: Text(
                        widget.profile.data["bio"],
                        style: Constants.TEXT_STYLE_BIO,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  height: 80,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('${widget.profile.data["name"]}',
                          style: Constants.TEXT_STYLE_CAPTION_DARK
                      ),
                      FlatButton(
                        child: Text(
                            reported?'Reported':'Report',
                            style: Constants.FLAT_RED_BUTTON_STYLE
                        ),
                        onPressed: () {
                          if(reported) {
                            Fluttertoast.showToast(msg: "already reported");
                          } else {
                            setState(() {
                              reported = true;
                            });
                            widget.backend.report(widget.profile.documentID);
                            Fluttertoast.showToast(msg: "reported user");
                          }
                        },
                      ),
                    ],
                  ),
                  color: Constants.BACKGROUND_COLOR,
                ),
              ),
            ],
          )
        ],
      )
    );
  }

  Widget BuildCard() {
    if(profilePages.isEmpty) {
      return Stack(
        overflow: Overflow.clip,
        children: <Widget>[
          Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: AspectRatio(
                  aspectRatio: 0.9,
                  child: Material(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network('https://www.elegantthemes.com/blog/wp-content/uploads/2016/03/500-internal-server-error-featured-image-1.png'),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  height: 80,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  child: Text('error',
                      style: Constants.TEXT_STYLE_CAPTION_DARK
                  ),
                  color: Constants.BACKGROUND_COLOR,
                ),
              ),
            ],
          )
        ],
      );
    } else {
      return profilePages[tapCounter%profilePages.length];
    }
  }
}

