import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_myinsta/pages/signin_page.dart';
import 'package:flutter_myinsta/services/prefs_service.dart';
import 'package:flutter_myinsta/services/utils_service.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;

  static Future<FirebaseUser> signInUser(
      BuildContext context, String email, String password) async {
    try {
      _auth.signInWithEmailAndPassword(email: email, password: password);
      final FirebaseUser user = await _auth.currentUser();
      return user;
    } catch (e) {
      Utils.fireToast('SignInWithEmailAndPassword Error : $e');
    }
    return null;
  }

  static Future<FirebaseUser> signUpUser(
      BuildContext context, String email, String password) async {
    try {
      var authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = authResult.user;
      return user;
    } catch (e) {
      Utils.fireToast('createUserWithEmailAndPassword Error : $e');
    }
    return null;
  }

  static void signOutUser(BuildContext context) {
    _auth.signOut();
    Prefs.removeUserId().then((value) {
      Navigator.pushReplacementNamed(context, SignInPage.id);
    });
  }
}
