import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:timperial/config.dart';
import 'package:timperial/auth.dart';
import 'package:timperial/backend.dart';
import 'package:timperial/profile_pages/upload_profile_picture.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({this.auth, this.onSignedOut, this.toMatchPage, this.toSwipePage});

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final VoidCallback toMatchPage;
  final VoidCallback toSwipePage;

  final BaseBackend backend = Backend();

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final formKey = new GlobalKey<FormState>();
  TextEditingController nameTextController = new TextEditingController();
  TextEditingController snapchatTextController = new TextEditingController();
  TextEditingController bioTextController = new TextEditingController();
  List<Map> profilePages = [];

  void validateAndSubmit() {
    if(validateAndSave()) {
      widget.backend.updateBio(bioTextController.text);
      //widget.reloadPageCallback(); // I don't think I need this
    }
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if(form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void removeProfilePage(int index) {
    setState(() {
      profilePages.removeAt(index);
    });
  }

  Future openUploadProfilePicture(context, bool fromCamera) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => UploadProfilePicture(fromCamera: fromCamera,)));
  }

  void deleteProfilePage(String imageURL) {
    setState(() {
      profilePages.removeWhere((page) => page["image_url"] == imageURL);
    });
    widget.backend.updateProfilePages(profilePages);
  }

  @override
  void initState() {
    super.initState();

    widget.backend.getOwnUser().then((userDocument) {
      setState(() {
        if(userDocument.data["name"] != null) {
          nameTextController.text = userDocument.data["name"];
        }
        if(userDocument.data["snapchat"] != null) {
          snapchatTextController.text = userDocument.data["snapchat"];
        }
        if(userDocument.data["bio"] != null) {
          bioTextController.text = userDocument.data["bio"];
        }
        if(userDocument.data["profile_pages"] != null) {
          print(userDocument.data["profile_pages"].toString());
          print(userDocument.data["profile_pages"][0].runtimeType);
          userDocument.data["profile_pages"].forEach((jsonMap) {
            String imageURL = jsonMap["image_url"];
            profilePages.add({"image_url":imageURL});
          });
        }
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
                padding: EdgeInsets.all(8.0),
                children: buildInputs() + buildImages(context)
              ),
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

  List<Widget> buildInputs() {
    return [
      TextFormField(
          controller: nameTextController,
          validator: (value) {
            if(value.length > 50) {
              return 'you are over the 50 character limit';
            } else if (value.length == 0) {
              return 'enter your name';
            }
            return null;
          }
      ),
      TextFormField(
          controller: snapchatTextController,
          validator: (value) {
            if(value.length > 50) {
              return 'you are over the 50 character limit';
            } else if (value.length == 0) {
              return 'please enter your snapchat (or number if you dont have it)';
            }
            return null;
          }
      ),
      TextFormField(
        keyboardType: TextInputType.multiline,
        minLines: 2,
        maxLines: 5,
        controller: bioTextController,
        validator: (value) => value.length > 150 ? 'you are over the 150 character limit' : null
      ),
      FlatButton(
        child: Text(
          'Update Profile',
          style: TextStyle(
            color: Constants.HIGHLIGHT_COLOR,
            fontWeight: FontWeight.w800,
            fontSize: 16.5,
          ),
        ),
        onPressed: () {
          validateAndSubmit();
        },
      ),
    ];
  }

  List<Widget> buildImages(BuildContext context) {
    List<Widget> imageWidgets = [];
    profilePages.forEach((page) {
      imageWidgets.add(
        Stack(
          overflow: Overflow.clip,
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: AspectRatio(
                aspectRatio: 0.9,
                child: Material(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(page["image_url"]),
                ),
              ),
            ),
            Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Constants.DELETE_IMAGE_ICON),
                  onPressed: () {
                    deleteProfilePage(page["image_url"]);
                  }
                )
            ),
          ],
        )
      );
    });

    if(profilePages.length < 3) {
      imageWidgets.add(
        RaisedButton(
          child: Icon(Constants.ADD_IMAGE_ICON),
          onPressed: () {
            openUploadProfilePicture(context, false);
          },
        )
      );
    }

    return imageWidgets;
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
                print("go to match page button pressed");
                widget.toMatchPage();
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
              }
          ),
          Spacer(),
        ],
      ),
    );
  }
}
