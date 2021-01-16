import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timperial/config.dart';
import 'package:timperial/auth.dart';
import 'package:timperial/backend.dart';
import 'package:timperial/profile_pages/upload_profile_picture.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:io' show Platform;

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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController nameTextController = new TextEditingController();
  TextEditingController snapchatTextController = new TextEditingController();
  TextEditingController bioTextController = new TextEditingController();
  List<Map> profilePages = [];
  DocumentSnapshot user;
  String currentGender = "gender";
  bool selectGenderError = false;
  bool genderChanged = false;
  bool firstGenderUpload = false;
  List<String> genders = [
    "male",
    "female",
    "other"
  ];
  String currentPreference = "preference";
  bool selectPreferenceError = false;
  bool preferenceChanged = false;
  bool firstPreferenceUpload = false;
  List<String> preferences = [
    "looking for men",
    "looking for women",
    "looking for both"
  ];

  void validateAndSubmit() {
    if(validateAndSave()) {
      FocusScope.of(context).unfocus();
      widget.backend.updateProfileInfo(
          bioTextController.text,
          nameTextController.text,
          snapchatTextController.text,
          currentGender,
          currentPreference
      );
      if(firstPreferenceUpload && firstGenderUpload) {
        widget.backend.addToStacks(
            currentGender,
            currentPreference
        );
      }
      firstGenderUpload = false;
      firstPreferenceUpload = false;
      setState(() {
        genderChanged = true;
        preferenceChanged = true;
      });
      Fluttertoast.showToast(msg: "profile updated");
    }
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if(form.validate() && currentGender != "gender" && currentPreference != "preference" && user != null) {
      form.save();
      return true;
    } else {
      if(currentGender == "gender") {
        setState(() {
          selectGenderError = true;
        });
      }
      if(currentPreference == "preference") {
        setState(() {
          selectPreferenceError = true;
        });
      }
      return false;
    }
  }

  void removeProfilePage(int index) {
    setState(() {
      profilePages.removeAt(index);
    });
  }

  Future openUploadProfilePicture(context, bool fromCamera) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => UploadProfilePicture(reloadProfilePages: reloadProfilePages ,fromCamera: fromCamera)));
  }

  void deleteProfilePage(String imageURL) {
    setState(() {
      profilePages.removeWhere((page) => page["image_url"] == imageURL);
    });
    widget.backend.updateProfilePages(profilePages);
  }

  void reloadProfilePages() {
    print("reloading profile page");
    widget.backend.getOwnUser(reload: true).then((userDocument) {
      setState(() {
        profilePages = [];
        if(userDocument.data["profile_pages"] != null) {
          print("number of profile pages ${userDocument.data["profile_pages"].length}");
          print(userDocument.data["profile_pages"].toString());
          print(userDocument.data["profile_pages"][0].runtimeType);
          userDocument.data["profile_pages"].forEach((jsonMap) {
            String imageURL = jsonMap["image_url"];
            profilePages.add({"image_url":imageURL});
          });
        }
      });
    });
    print("profile pages reloaded");
  }

  void showGenderSelector(BuildContext context) {
    if(Platform.isIOS) {
      showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return CupertinoActionSheet(
              title: Text("Gender"),
              actions: <Widget>[
                CupertinoActionSheetAction(
                  child: Text("male"),
                  onPressed: () {
                    setState(() {
                      currentGender = "male";
                      selectGenderError = false;
                    });
                  },
                ),
                CupertinoActionSheetAction(
                  child: Text("female"),
                  onPressed: () {
                    setState(() {
                      currentGender = "female";
                      selectGenderError = false;
                    });
                  },
                ),
                CupertinoActionSheetAction(
                  child: Text("other"),
                  onPressed: () {
                    setState(() {
                      currentGender = "other";
                      selectGenderError = false;
                    });
                  },
                ),
              ],
            );
          }
      );
    } else {
      _scaffoldKey.currentState.showBottomSheet<void>(
        (BuildContext context) {
          return Container(
            height: 150,
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FlatButton(
                    child: const Text("Male"),
                    onPressed: () {
                      setState(() {
                        currentGender = "male";
                        selectGenderError = false;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: const Text(
                      "Female",
                    ),
                    onPressed: () {
                      setState(() {
                        currentGender = "female";
                        selectGenderError = false;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: const Text(
                      "Other",
                    ),
                    onPressed: () {
                      setState(() {
                        currentGender = "other";
                        selectGenderError = false;
                      });
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          );
        },
      );
    }
  }

  void showPreferenceSelector(BuildContext context) {
    if(Platform.isIOS) {
      showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return CupertinoActionSheet(
              title: Text("Preference"),
              actions: <Widget>[
                CupertinoActionSheetAction(
                  child: Text("looking for men"),
                  onPressed: () {
                    setState(() {
                      currentPreference = "looking for men";
                      selectPreferenceError = false;
                    });
                  },
                ),
                CupertinoActionSheetAction(
                  child: Text("looking for women"),
                  onPressed: () {
                    setState(() {
                      currentPreference = "looking for women";
                      selectPreferenceError = false;
                    });
                  },
                ),
                CupertinoActionSheetAction(
                  child: Text("looking for both"),
                  onPressed: () {
                    setState(() {
                      currentPreference = "looking for both";
                      selectPreferenceError = false;
                    });
                  },
                ),
              ],
            );
          }
      );
    } else {
      _scaffoldKey.currentState.showBottomSheet<void>(
            (BuildContext context) {
          return Container(
            height: 150,
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FlatButton(
                    child: const Text(
                      "looking for men"
                    ),
                    onPressed: () {
                      setState(() {
                        currentPreference = "looking for men";
                        selectPreferenceError = false;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: const Text(
                      "looking for women",
                    ),
                    onPressed: () {
                      setState(() {
                        currentPreference = "looking for women";
                        selectPreferenceError = false;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: const Text(
                      "looking for both",
                    ),
                    onPressed: () {
                      setState(() {
                        currentPreference = "looking for both";
                        selectPreferenceError = false;
                      });
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();

    widget.backend.getOwnUser().then((userDocument) {
      setState(() {
        user = userDocument;
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
          userDocument.data["profile_pages"].forEach((jsonMap) {
            String imageURL = jsonMap["image_url"];
            profilePages.add({"image_url":imageURL});
          });
        }
        if(userDocument.data["gender"] != null) {
          if(userDocument.data["gender"] == "") {
            firstGenderUpload = true;
            currentGender = "gender";
          } else {
            currentGender = userDocument.data["gender"];
          }
        } else {
          firstGenderUpload = true;
          currentGender = "gender";
        }
        if(userDocument.data["preference"] != null) {
          if(userDocument.data["preference"] == "") {
            firstPreferenceUpload = true;
            currentPreference = "preference";
          } else {
            currentPreference = userDocument.data["preference"];
          }
        } else {
          firstPreferenceUpload = true;
          currentPreference = "preference";
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Constants.SECONDARY_COLOR,
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Form(
                  key: formKey,
                  child: ListView(
                    padding: EdgeInsets.all(8.0),
                    children: [SizedBox(height: 16,), buildImageCarousel(), SizedBox(height: 8,)] + buildInputs(context)
                  ),
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
      ),
    );
  }

  List<Widget> buildInputs(BuildContext scaffoldContext) {
    List<Widget> widgets = [
      Padding(
        padding: const EdgeInsets.fromLTRB(0.0,20.0,0.0,0.0),
        child: Text("Name", style: Constants.TEXT_STYLE_HINT_DARK,),
      ),
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
      Padding(
        padding: const EdgeInsets.fromLTRB(0.0,20.0,0.0,0.0),
        child: Text("Snapchat", style: Constants.TEXT_STYLE_HINT_DARK,),
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
      Padding(
        padding: const EdgeInsets.fromLTRB(0.0,20.0,0.0,0.0),
        child: Text("My Bio", style: Constants.TEXT_STYLE_HINT_DARK,),
      ),
      TextFormField(
        keyboardType: TextInputType.multiline,
        minLines: 2,
        maxLines: 5,
        controller: bioTextController,
        validator: (value) => value.length > 150 ? 'you are over the 150 character limit' : null
      )
    ];

    if(user != null && !genderChanged) {
      if(user.data["gender"] != "male" && user.data["gender"] != "female" && user.data["gender"] != "other") {
        widgets.add(
          RaisedButton(
            child: Text(currentGender),
            onPressed: () {
              showGenderSelector(scaffoldContext);
            },
          )
        );
        if(currentGender == "male" || currentGender == "female" || currentGender == "other") {
          widgets.add(
            Text("this cannot be changed once you hit 'update profile'")
          );
        } else if (selectGenderError) {
          widgets.add(
            Text("please select a gender", style: Constants.TEXT_STYLE_ERROR,)
          );
        }
      }
    }

    if(user != null && !preferenceChanged) {
      if(user.data["preference"] != "looking for men" && user.data["preference"] != "looking for women" && user.data["preference"] != "looking for both") {
        widgets.add(
            RaisedButton(
              child: Text(currentPreference),
              onPressed: () {
                showPreferenceSelector(scaffoldContext);
              },
            )
        );
        if(currentPreference == "looking for men" || currentPreference == "looking for women" || currentPreference == "looking for both") {
          widgets.add(
              Text("this cannot be changed once you hit 'update profile'")
          );
        } else if (selectPreferenceError) {
          widgets.add(
              Text("please select a preference", style: Constants.TEXT_STYLE_ERROR,)
          );
        }
      }
    }

    widgets.addAll([
      SizedBox(height: 20,),
      FlatButton(
        child: Text(
          'Update Profile',
          style: Constants.FLAT_BUTTON_STYLE
        ),
        onPressed: () {
          validateAndSubmit();
        },
      ),
      FlatButton(
        child: Text(
          'Log Out',
          style: Constants.FLAT_BUTTON_STYLE
        ),
        onPressed: widget.onSignedOut,
      ),
    ]);

    return widgets;
  }

  Widget buildImageCarousel() {
    final List<Widget> imageSliders = profilePages.map((page) => Container(
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.network(page["image_url"])
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Constants.DELETE_IMAGE_ICON, color: Colors.white,),
                    onPressed: () {
                      deleteProfilePage(page["image_url"]);
                    }
                  )
                ),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(200, 0, 0, 0),
                          Color.fromARGB(0, 0, 0, 0)
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Text(
                      'Picture ${profilePages.indexOf(page) + 1}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
    )).toList();

    if(imageSliders.length < 3) {
      imageSliders.add(
        Container(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: RaisedButton(
                      onPressed: () {
                        openUploadProfilePicture(context, false);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.add_a_photo, color: Constants.IMPERIAL_MEDIUM_BLUE,),
                          Text("Add a photo", style: TextStyle(color: Constants.IMPERIAL_MEDIUM_BLUE),)
                        ],
                      ),
                    ),
                  )
                ],
              )
          ),
        ),
      );
    }

    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: false,
        aspectRatio: 1.13,
        enlargeCenterPage: true,
      ),
      items: imageSliders,
    );
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
              icon: Icon(Constants.EXPLORE_PAGE_UNSELECTED_ICON, color: Constants.UNSELECTED_ICON_COLOR, size: 27.5,),
              color: Constants.INACTIVE_COLOR_DARK,
              onPressed: () {
                print("go to match page button pressed");
                widget.toMatchPage();
              }
          ),
          Spacer(),
          IconButton(
            icon: Icon(Constants.SWIPE_PAGE_UNSELECTED_ICON, color: Constants.UNSELECTED_ICON_COLOR, size: 27.5),
            onPressed: () {
              print("go to swipe page button pressed");
              widget.toSwipePage();
            },
          ),
          Spacer(),
          IconButton(
              icon: Icon(Constants.PROFILE_PAGE_SELECTED_ICON, color: Constants.SELECTED_ICON_COLOR, size: 32.0),
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
