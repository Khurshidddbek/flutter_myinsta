import 'dart:convert';
import 'package:flutter_myinsta/services/data_service.dart';
import 'package:http/http.dart';

class HttpService {
  static String BASE = 'fcm.googleapis.com';
  static String API_SEND = '/fcm/send';
  static Map<String, String> headers = {
    'Authorization': 'key=AAAAgMSaDTI:APA91bGobFIWy5AG97-yShUmSyBXUeg_3HPJ3SWXqB3LRfLwoAyB8U7hnpLbBoS6UA4Xv9cBZ_HN_8nL4S1htEEPjtFP2g9a5GEe8JtMX41J56y74t7lFyXUsKBMNTkZ1GfM-t2lTpgh',
    'Content-Type': 'application/json'
  };

  static Future<String> POST(Map<String, dynamic> params) async {
    var uri = Uri.https(BASE, API_SEND);
    var response = await post(uri, headers: headers, body: jsonEncode(params));
    if(response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }
    return null;
  }

  static Map<String, dynamic> paramCreate(String username, String fcmToken) {

    Map<String, dynamic> params = new Map();
    params.addAll({
      'notification': {
        'title': 'My Instagram',
        'body': '$username followed you!'
      },
      'registration_ids': [fcmToken],
      'click_action': 'FLUTTER_NOTIFICATION_CLICK'
    });
    return params;
  }
}