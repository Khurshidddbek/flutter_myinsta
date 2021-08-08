import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myinsta/services/prefs_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static void fireToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static bool emailAndPasswordValidation(String email, String password) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (!emailValid) {
      Utils.fireToast('Check your email');
      return false;
    }

    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    if (!(regExp.hasMatch(password))) {
      Utils.fireToast('Check your password');
      return false;
    }

    return true;
  }

  static String currentDate() {
    DateTime now = DateTime.now();

    String convertedDateTime =
        "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString()}:${now.minute.toString()}";
    return convertedDateTime;
  }

  static Future<bool> commonDialog(BuildContext context, String title, String content, bool isSingle) async {
    return await showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          // Button : Cancel
          !isSingle ?
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ) : SizedBox.shrink(),

          // Button : Confirm
          FlatButton(
            child: Text('Confirm'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    });
  }


  // Device info
  static Future<Map<String, String>> deviceParams() async {
    Map<String, String> params = Map();
    var deviceInfo = DeviceInfoPlugin();
    String fcmToken = await Prefs.loadFCM();

    if (Platform.isIOS) {
      var iOSDeviceInfo = await deviceInfo.iosInfo;
      params.addAll({
        'device_id' : iOSDeviceInfo.identifierForVendor,
        'device_type' : 'I',
        'device_token' : fcmToken,
      });
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      params.addAll({
        'device_id' : androidDeviceInfo.androidId,
        'device_type' : 'A',
        'device_token' : fcmToken,
      });
    }

    return params;
  }
}
