import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timperial/auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timperial/config.dart';

class CreateAccountPage extends StatefulWidget {
  CreateAccountPage({this.auth, this.toLoginPage});

  final BaseAuth auth;
  final VoidCallback toLoginPage;

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

enum Page {
  createAccount,
  eula,
  verify,
}

class _CreateAccountPageState extends State<CreateAccountPage> {

  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _confirmPassword;
  Page _currentPage = Page.createAccount;

  void openPolicyDisclaimer() {
    showDialog(
        context: context,
        child: AlertDialog(
          title: Text("EULA"),
          content: Container(
              width: MediaQuery.of(context).size.width * 0.90,
              height: MediaQuery.of(context).size.height * 0.90,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Text(
                          Constants.EULA_AGREEMENT_TEXT
                      ),
                    ),
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(
                          color: Constants.DARK_TEXT,
                          width: 0.5,
                        )
                    ),
                    elevation: 0,
                    color: Constants.BACKGROUND_COLOR,
                    child: Text('By clicking you agree to the above policy'),
                    onPressed: () {
                      validateAndSubmit();
                      Navigator.pop(context);
                    },
                  )
                ],
              )
          ),
        )
    );
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

  Future<void> validateAndSubmit() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    if(validateAndSave()) {
      try {
        String userId = await widget.auth.createUserWithEmailAndPassword(_email, _password).catchError((e) => {
          Fluttertoast.showToast(msg: "account creation failed")
        });
        setState(() {
          _currentPage = Page.verify;
        });
        //widget.onSignedIn();
        //Navigator.pop(context);
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/login_page_background.png'), fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: buildInputs() + buildButtons(),
                ),
              ),
            ),
          )
        ],
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  List<Widget> buildInputs() {
    if(_currentPage == Page.verify) {
      return [
        SizedBox(height: 150),
        Text("You should have recieved a verification link in your email. Please verify your email and log in using the email and password you provided")
      ];
    } else if (_currentPage == Page.eula) {
      return [
        SizedBox(height: 90),
        Text("Please read and accept the following terms and conditions to keep using the app"),
        SizedBox(height: 16.0,),
        Expanded(
          flex: 8,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              scrollDirection: Axis.vertical,
              child: Text(Constants.EULA_AGREEMENT_TEXT),
            ),
          )
        )
      ];
    } else {
      return [
        SizedBox(height: 150,),
        // First input
        Theme(
          data: ThemeData(
            primaryColor: Constants.INACTIVE_COLOR_LIGHT,
            accentColor: Constants.INACTIVE_COLOR_LIGHT,
            hintColor: Constants.HIGHLIGHT_COLOR,
            cursorColor: Constants.INACTIVE_COLOR_LIGHT,
            textSelectionColor: Constants.INACTIVE_COLOR_LIGHT,
            inputDecorationTheme: InputDecorationTheme(
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Constants.INACTIVE_COLOR_LIGHT)
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Constants.INACTIVE_COLOR_LIGHT)
              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Constants.INACTIVE_COLOR_LIGHT)
              ),
            ),
          ),
          child: TextFormField(
            style: TextStyle(
                color: Constants.INACTIVE_COLOR_LIGHT
            ),
            decoration: InputDecoration(
                labelText: 'Enter email',
                labelStyle: TextStyle(
                  color: Constants.INACTIVE_COLOR_LIGHT,
                )
            ),
            validator: (value) {
              print("running validator");
              List<String> allowedExtensions = ["imperial"];
              String regexExtensions = "";
              regexExtensions = regexExtensions + "(?:(${allowedExtensions.first})";
              allowedExtensions.sublist(1).forEach((extension) {
                regexExtensions = regexExtensions + "(?:($extension)";
              });
              RegExp emailValidator = new RegExp(
                r"[\w\d\.]+@(?:imperial)(?:\.ac\.uk)",
                caseSensitive: false,
                multiLine: false,
              );
              if(value.isEmpty) {
                return 'Email cannot be empty';
              } else if (!emailValidator.hasMatch(value)) {
                return 'Please enter an @imperial.ac.uk email address';
              }
              return null;
            },
            onSaved: (value) => _email = value,
          ),
        ),
        SizedBox(height: 30,),
        // Second input
        Theme(
          data: ThemeData(
            primaryColor: Constants.INACTIVE_COLOR_LIGHT,
            accentColor: Constants.INACTIVE_COLOR_LIGHT,
            hintColor: Constants.HIGHLIGHT_COLOR,
            cursorColor: Constants.INACTIVE_COLOR_LIGHT,
            textSelectionColor: Constants.INACTIVE_COLOR_LIGHT,
            inputDecorationTheme: InputDecorationTheme(
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Constants.INACTIVE_COLOR_LIGHT)
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Constants.INACTIVE_COLOR_LIGHT)
              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Constants.INACTIVE_COLOR_LIGHT)
              ),
            ),
          ),
          child: TextFormField(
            style: TextStyle(
                color: Constants.INACTIVE_COLOR_LIGHT
            ),
            decoration: InputDecoration(
                labelText: 'Enter password',
                labelStyle: TextStyle(
                  color: Constants.INACTIVE_COLOR_LIGHT,
                )
            ),
            validator: (value) => value.isEmpty ? 'Password cannot be empty' : null,
            obscureText: true,
            onSaved: (value) => _password = value,
          ),
        ),
        //SizedBox(height: 30,),
      ];
    }
  }

  List<Widget> buildButtons() {
    if (_currentPage == Page.verify) {
      return [
        Spacer(),
        SizedBox(
          height: 60.0,
          width: 220,
          child: ButtonTheme(
            buttonColor: Constants.BACKGROUND_COLOR,
            minWidth: 220,
            child: RaisedButton(
              elevation: 0,
              onPressed: widget.toLoginPage,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)),
              padding: EdgeInsets.all(0.0),
              child: Ink(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xff4EB9E8), Color(0xff6B95DE)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30.0)
                ),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 220.0, minHeight: 50.0),
                  alignment: Alignment.center,
                  child: Text(
                    "Back To Login",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ];
    } else if (_currentPage == Page.eula) {
      return [
        Spacer(),
        SizedBox(
          height: 60.0,
          width: 220,
          child: ButtonTheme(
            buttonColor: Constants.BACKGROUND_COLOR,
            minWidth: 220,
            child: RaisedButton(
              elevation: 0,
              onPressed: validateAndSubmit,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)),
              padding: EdgeInsets.all(0.0),
              child: Ink(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xff4EB9E8), Color(0xff6B95DE)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30.0)
                ),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 220.0, minHeight: 50.0),
                  alignment: Alignment.center,
                  child: Text(
                    "Agree",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        FlatButton(
          child: Text(
            'Disagree',
            style: Constants.TEXT_STYLE_HINT_DARK,
          ),
          onPressed: () {
            setState(() {
              _currentPage = Page.createAccount;
            });
          },
        )
      ];
    } else {
      return [
        Spacer(),
        SizedBox(
          height: 60.0,
          width: 220,
          child: ButtonTheme(
            buttonColor: Constants.BACKGROUND_COLOR,
            minWidth: 220,
            child: RaisedButton(
              elevation: 0,
              onPressed: () {
                if(validateAndSave()) {
                  setState(() {
                    _currentPage = Page.eula;
                  });
                }
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)),
              padding: EdgeInsets.all(0.0),
              child: Ink(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xff4EB9E8), Color(0xff6B95DE)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30.0)
                ),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 220.0, minHeight: 50.0),
                  alignment: Alignment.center,
                  child: Text(
                    "Create Account",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        FlatButton(
          child: Text(
            'Have an account? Login',
            style: Constants.TEXT_STYLE_HINT_DARK,
          ),
          onPressed: widget.toLoginPage,
        )
      ];
    }
  }
}
