import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_myinsta/model/user_model.dart';
import 'package:flutter_myinsta/services/prefs_service.dart';

class DataService {
  static Future storeUser(User user) async {
    user.uid = await Prefs.loadUserId();
    final instance = Firestore.instance;
    return instance
        .collection('users')
        .document(user.uid)
        .setData(user.toJson());
  }

  static Future<User> loadUser() async {
    String uid = await Prefs.loadUserId();
    final instance = Firestore.instance;
    var value = await instance.collection('users').document(uid).get();
    return User.fromJson(value.data);
  }

  static Future updateUser(User user) async {
    String uid = await Prefs.loadUserId();
    final instance = Firestore.instance;
    return instance.collection('users').document(uid).updateData(user.toJson());
  }

  static Future<List<User>> searchUsers(String keyword) async {
    List<User> users = List();
    String uid = await Prefs.loadUserId();

    final instance = Firestore.instance;

    var querySnapshot = await instance
        .collection('users')
        .orderBy('email')
        .startAt([keyword]).getDocuments();

    querySnapshot.documents.forEach((user) {
      User respUser = User.fromJson(user.data);

      if (respUser.uid != uid) users.add(respUser);
    });
    return users;
  }
}
