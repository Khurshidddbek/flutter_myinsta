import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_myinsta/pages/signin_page.dart';
import 'package:flutter_myinsta/services/prefs_service.dart';
import 'package:flutter_myinsta/services/utils_service.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;

  static Future<Map<String, FirebaseUser>> signInUser(
      BuildContext context, String email, String password) async {
    try {
      _auth.signInWithEmailAndPassword(email: email, password: password);
      final FirebaseUser firebaseUser = await _auth.currentUser();
      return ({'SUCCESS': firebaseUser});
    } catch (e) {
      Utils.fireToast('SignInWithEmailAndPassword Error : $e');
    }
    return ({'ERROR': null});
  }

  static Future<Map<String, FirebaseUser>> signUpUser(
      BuildContext context, String email, String password) async {
    try {
      var authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = authResult.user;
      return ({'SUCCESS': firebaseUser});
    } catch (e) {
      if (e.errorCode == 'ERROR_EMAIL_ALREADY_IN_USE')
        return ({'ERROR_EMAIL_ALREADY_IN_USE': null});
    }
    return ({'ERROR': null});
  }

  static void signOutUser(BuildContext context) {
    _auth.signOut();
    Prefs.removeUserId().then((value) {
      Navigator.pushReplacementNamed(context, SignInPage.id);
    });
  }
}
