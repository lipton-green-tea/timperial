import 'package:flutter/material.dart';
import 'auth.dart';
import 'config.dart';
import 'package:timperial/login_pages/root_login_page.dart';
import 'package:timperial/swipe_pages/swipe_page.dart';
import 'package:timperial/error_pages/error_page.dart';
import 'package:timperial/error_pages/unverified_email_page.dart';
import 'package:timperial/match_pages/match_page.dart';
import 'package:timperial/profile_pages/profile_page.dart';
import 'package:timperial/login_pages/create_account_page.dart';
import 'package:timperial/login_pages/forgot_password_page.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});
  final BaseAuth auth;
  // final PushNotificationsManager pushNotificationsManager = new PushNotificationsManager();

  @override
  State<StatefulWidget> createState() => _RootPageState();
}

enum AuthStatus {
  notSignedIn,
  signedIn
}

enum Pages {
  swipe,
  profile,
  match,
  test,
  login,
  register,
  forgotPassword,
  unverified
}

class _RootPageState extends State<RootPage> {

  AuthStatus _authStatus = AuthStatus.notSignedIn;
  Pages _currentPage;

  void initState() {
    super.initState();
    setState(() {
      _currentPage = Pages.swipe;
    });
    widget.auth.currentUser().then((userId) {
      setState(() {
        _authStatus = userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });

    // widget.pushNotificationsManager.init();
  }

  void _signedIn() {
    _authStatus = AuthStatus.signedIn;
    _toSwipePage();
  }

  void _signedOut() {
    widget.auth.signOut();
    setState(() {
      _authStatus = AuthStatus.notSignedIn;
    });
  }

  void _toUnverifiedPage() {
    setState(() {
      _authStatus = AuthStatus.signedIn;
      _currentPage = Pages.unverified;
    });
  }

  void _toLoginPage() {
    setState(() {
      _authStatus = AuthStatus.notSignedIn;
      _currentPage = Pages.login;
    });
  }

  void _toCreateAccountPage() {
    setState(() {
      _currentPage = Pages.register;
    });
  }

  void _toForgotPasswordPage() {
    setState(() {
      _currentPage = Pages.forgotPassword;
    });
  }

  void _toSwipePage() {
    setState(() {
      _currentPage = Pages.swipe;
    });
  }

  void _toMyProfilePage() {
    setState(() {
      _currentPage = Pages.profile;
    });
  }

  void _toMatchPage() {
    setState(() {
      _currentPage = Pages.match;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_authStatus == AuthStatus.notSignedIn) {
      if(_currentPage == Pages.register) {
        return CreateAccountPage(
          auth: widget.auth,
          toLoginPage: _toLoginPage
        );
      } else if (_currentPage == Pages.forgotPassword) {
        return ForgotPasswordPage(
            auth: widget.auth,
            toLoginPage: _toLoginPage
        );
      } else {
        return LoginPage(
          auth: widget.auth,
          onSignedIn: _signedIn,
          toUnverifiedPage: _toUnverifiedPage,
          toCreateAccountPage: _toCreateAccountPage,
          toForgotPasswordPage: _toForgotPasswordPage,
        );
      }
    } else {
      if(_currentPage == Pages.swipe || _currentPage == Pages.unverified) {
        return SwipePage(
          onSignedOut: _signedOut,
          toMatchPage: _toMatchPage,
          toProfilePage: _toMyProfilePage,
        );
      } else if(_currentPage == Pages.profile) {
        return ProfilePage(
          auth: widget.auth,
          onSignedOut: _signedOut,
          toMatchPage: _toMatchPage,
          toSwipePage: _toSwipePage,
        );
      } else if(_currentPage == Pages.match) {
        return MatchPage(
          toProfilePage: _toMyProfilePage,
          toSwipePage: _toSwipePage,
        );
      } else if(_currentPage == Pages.unverified) {
        return UnverifiedEmailPage(
          onLogout: _toLoginPage,
        );
      } else {
        return ErrorPage(toHomePage: _toSwipePage,);
      }
    }
  }
}
