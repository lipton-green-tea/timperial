import 'package:flutter/material.dart';
import 'auth.dart';
import 'config.dart';
import 'package:timperial/login_pages/root_login_page.dart';
import 'package:timperial/swipe_pages/swipe_page.dart';
import 'package:timperial/error_pages/error_page.dart';

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
  discover,
  test
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
    setState(() {
      _authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      _authStatus = AuthStatus.notSignedIn;
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

  void _toDiscoverPage() {
    setState(() {
      _currentPage = Pages.discover;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_authStatus == AuthStatus.notSignedIn) {
      return LoginPage(
        onSignedIn: _signedIn,
      );
    } else {
      if(_currentPage == Pages.swipe) {
        return SwipePage(
          onSignedOut: _signedOut,
          toMatchPage: _toDiscoverPage,
          toProfilePage: _toMyProfilePage,
        );
//      } else if(_currentPage == Pages.profile) {
//        return MyProfilePage(
//          auth: widget.auth,
//          onSignedOut: _signedOut,
//          toDiscoverPage: _toDiscoverPage,
//          toSwipePage: _toSwipePage,
//        );
//      } else if(_currentPage == Pages.discover) {
//        return ExplorePage(
//          toMyProfilePage: _toMyProfilePage,
//          toSwipePage: _toSwipePage,
//        );
      } else {
        return ErrorPage(toHomePage: _toSwipePage,);
      }
    }
  }
}
