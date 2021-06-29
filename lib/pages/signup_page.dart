import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myinsta/pages/signin_page.dart';
import 'package:flutter_myinsta/services/auth_service.dart';
import 'package:flutter_myinsta/services/prefs_service.dart';
import 'package:flutter_myinsta/services/utils_service.dart';

import 'home_page.dart';

class SignUpPage extends StatefulWidget {
  static final String id = 'signup_page';

  const SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // values
  var _fullNameController = TextEditingController();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  var _cPasswordController = TextEditingController();
  var isLoading = false;

  _doSignUp() {
    String name = _fullNameController.text.toString().trim();
    String email = _emailController.text.toString().trim();
    String password = _passwordController.text.toString().trim();
    String cPassword = _cPasswordController.text.toString().trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) return;
    if (password != cPassword) {
      Utils.fireToast('Password and confirm password does not match!');
      return;
    }

    if (!(Utils.emailAndPasswordValidation(email, password))) return;

    setState(() {
      isLoading = true;
    });
    AuthService.signUpUser(context, email, password).then((firebaseUser) => {
          _getFirebaseUser(firebaseUser),
        });
  }

  _getFirebaseUser(FirebaseUser firebaseUser) async {
    setState(() {
      isLoading = false;
    });
    if (firebaseUser != null) {
      await Prefs.saveUserId(firebaseUser.uid);
      Navigator.pushReplacementNamed(context, HomePage.id);
    } else {
      Utils.fireToast("Check your informations");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
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
              child: Column(
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

                      // TextField : Full name
                      Container(
                        height: 50,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.white54.withOpacity(0.2),
                        ),
                        child: TextField(
                          controller: _fullNameController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Full name',
                            hintStyle:
                                TextStyle(color: Colors.white54, fontSize: 16),
                            border: InputBorder.none,
                          ),
                        ),
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
                          controller: _passwordController,
                          obscureText: true,
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

                      // TextField : Confirm password
                      Container(
                        height: 50,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.white54.withOpacity(0.2),
                        ),
                        child: TextField(
                          controller: _cPasswordController,
                          obscureText: true,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Confirm password',
                            hintStyle:
                                TextStyle(color: Colors.white54, fontSize: 16),
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      // Button : Sign Up
                      GestureDetector(
                        onTap: _doSignUp,
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
                              'Sign Up',
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
                        "Already have an account? ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, SignInPage.id);
                          },
                          child: Text(
                            "Sign in",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                ],
              ),
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
