import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myinsta/pages/signup_page.dart';
import 'package:flutter_myinsta/services/auth_service.dart';
import 'package:flutter_myinsta/services/prefs_service.dart';
import 'package:flutter_myinsta/services/utils_service.dart';

import 'home_page.dart';

class SignInPage extends StatefulWidget {
  static final String id = 'signin_page';

  const SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // values
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  var isLoading = false;

  _doSignIn() {
    String email = _emailController.text.toString().trim();
    String password = _passwordController.text.toString().trim();
    if (email.isEmpty || password.isEmpty) return;

    if (!(Utils.emailAndPasswordValidation(email, password))) return;

    setState(() {
      isLoading = true;
    });
    AuthService.signInUser(context, email, password).then((map) => {
          _getFirebaseUser(map),
        });
  }

  _getFirebaseUser(map) async {
    setState(() {
      isLoading = false;
    });

    FirebaseUser firebaseUser;

    if (!map.containsKey('SUCCESS')) {
      Utils.fireToast('Check email or password');
      return;
    }

    firebaseUser = map['SUCCESS'];

    if (firebaseUser == null) return;

    await Prefs.saveUserId(firebaseUser.uid).then((value) => {
          Navigator.pushReplacementNamed(context, HomePage.id),
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30),
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xffFCAF45),
                  Color(0xffF56040),
                ]),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Text : Instagram
                      Text(
                        'Instagram',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 45,
                            fontFamily: 'Billabong'),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      // TextField : Email
                      Container(
                        height: 50,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.white54.withOpacity(0.2),
                        ),
                        child: TextField(
                          controller: _emailController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle:
                                TextStyle(color: Colors.white54, fontSize: 16),
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      // TextField : Password
                      Container(
                        height: 50,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.white54.withOpacity(0.2),
                        ),
                        child: TextField(
                          obscureText: true,
                          controller: _passwordController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle:
                                TextStyle(color: Colors.white54, fontSize: 16),
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      // Button : Sign in
                      GestureDetector(
                        onTap: _doSignIn,
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(
                                color: Colors.white54.withOpacity(0.2),
                                width: 2),
                          ),
                          child: Center(
                            child: Text(
                              'Sign in',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),

                  // GestureDetector : Sign Up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, SignUpPage.id);
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                ],
              ),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
