import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myinsta/main.dart';
import 'package:flutter_myinsta/pages/home_page.dart';
import 'package:flutter_myinsta/pages/signin_page.dart';
import 'package:flutter_myinsta/services/prefs_service.dart';

class SplashPage extends StatefulWidget {
  static final String id = 'splash_page';

  const SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // Firebase notification
  // ===========================================================================
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  _initNotification() {
    _firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print('Setting registered: $settings');
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);

      print('\n\n\nToken: $token\n\n\n\n\n');
      Prefs.saveFCM(token);
    });
  }

  // ===========================================================================


  _initTimer() {
    Timer(Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, MyApp.registered ? HomePage.id : SignInPage.id);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initTimer();

    _initNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        width: double.infinity,
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
                child: Center(
              child: Text(
                'Instagram',
                style: TextStyle(
                    color: Colors.white, fontSize: 45, fontFamily: 'Billabong'),
              ),
            )),

            // Text : All rights reserved
            Text(
              'All rights reserved',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
