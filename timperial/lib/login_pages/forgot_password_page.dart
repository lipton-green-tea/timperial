import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timperial/auth.dart';
import 'package:timperial/config.dart';
import 'package:timperial/backend.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({this.auth, this.toLoginPage});

  final BaseAuth auth;
  final VoidCallback toLoginPage;

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  final formKey = new GlobalKey<FormState>();

  String _email;
  bool resetSent = false;
  BaseBackend backend = new Backend();

  bool validateAndSave() {
    final form = formKey.currentState;
    if(form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    if(validateAndSave()) {
      try {
        await widget.auth.resetPassword(_email);
        setState(() {
          resetSent = true;
        });
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
                  children: buildInputs() + buildSubmitButtons(),
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
    if (resetSent) {
      return [
        SizedBox(height: 150,),
        Text("A reset password link has been sent to your inbox.")
      ];
    } else {
      return [
        SizedBox(height: 150,),
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
              labelText: 'Email',
              labelStyle: TextStyle(
                color: Constants.INACTIVE_COLOR_LIGHT,
              ),
            ),
            validator: (value) =>
            value.isEmpty
                ? 'Email cannot be empty'
                : null,
            onSaved: (value) => _email = value,
          ),
        ),
        SizedBox(height: 30,),
      ];
    }
  }

  List<Widget> buildSubmitButtons() {
    if (resetSent) {
      return [
        FlatButton(
          child: Text(
            'Back to Login',
            style: Constants.TEXT_STYLE_HINT_DARK,
          ),
          onPressed: widget.toLoginPage,
        ),
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
                    "Reset Password",
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
            'Back to Login',
            style: Constants.TEXT_STYLE_HINT_DARK,
          ),
          onPressed: widget.toLoginPage,
        ),
      ];
    }
  }
}
