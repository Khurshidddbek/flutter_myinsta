import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static Future<bool> saveUserId(String userId) async {
    Prefs.removeUserId();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('userId', userId);
  }

  static Future<String> loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('userId');
    return token;
  }

  static Future<bool> removeUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove('userId');
  }

  // Firebase token
  static Future<bool> saveFCM(String fcmToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('fcmToken', fcmToken);
  }

  static Future<String> loadFCM() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('fcmToken');

    return token;
  }
}
