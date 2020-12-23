import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

abstract class BaseAuth {
  static String userID;
  static FirebaseUser userObject;

  Future<FirebaseUser> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  Future<String> currentUser();
  Future<FirebaseUser> currentUserObject();
  Future<void> signOut();
  Future<void> resetPassword(String email);
}

class Auth implements BaseAuth {
  final _firebaseAuth = FirebaseAuth.instance;
  static String userID;
  static FirebaseUser userObject;


  Future<FirebaseUser> signInWithEmailAndPassword(String email, String password) async {
    FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user;
    return user;
  }

  Future<String> createUserWithEmailAndPassword(String email, String password) async {
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;
    await user.sendEmailVerification();
    return user.uid;
  }

  Future<String> currentUser() async {
    if(userID == null) {
      FirebaseUser user = await _firebaseAuth.currentUser();
      userObject = user;
      userID = user.uid;
    }
    return userID;
  }

  Future<FirebaseUser> currentUserObject() async {
    if(userObject == null) {
      FirebaseUser user = await _firebaseAuth.currentUser();
      userObject = user;
      userID = user.uid;
    }
    return userObject;
  }

  Future<String> currentUserEmail() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.email;
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future<void> resetPassword(String email) async {
    return await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}