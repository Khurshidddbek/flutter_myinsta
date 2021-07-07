import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_myinsta/model/post_model.dart';
import 'package:flutter_myinsta/model/user_model.dart';
import 'package:flutter_myinsta/services/prefs_service.dart';
import 'package:flutter_myinsta/services/utils_service.dart';

class DataService {
  static final _firestore = Firestore.instance;

  static String folder_users = "users";
  static String folder_posts = "posts";
  static String folder_feeds = "feeds";

  // User Related
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

  // Post Related
  static Future<Post> storePost(Post post) async {
    User me = await loadUser();

    post.uid = me.uid;
    post.fullName = me.fullName;
    post.imgUser = me.imgUrl;
    post.date = Utils.currentDate();

    String postId = _firestore
        .collection(folder_users)
        .document(me.uid)
        .collection(folder_posts)
        .document()
        .documentID;

    post.id = postId;

    await _firestore
        .collection(folder_users)
        .document(me.uid)
        .collection(folder_posts)
        .document(postId)
        .setData(post.toJson());

    return post;
  }

  static Future<Post> storeFeed(Post post) async {
    String uid = await Prefs.loadUserId();

    await _firestore
        .collection(folder_users)
        .document(uid)
        .collection(folder_feeds)
        .document(post.id)
        .setData(post.toJson());

    return post;
  }

  static Future<List<Post>> loadFeeds() async {
    List<Post> posts = List();
    String uid = await Prefs.loadUserId();
    var querySnapshot = await _firestore
        .collection(folder_users)
        .document(uid)
        .collection(folder_posts)
        .getDocuments();

    querySnapshot.documents.forEach((element) {
      Post post = Post.fromJson(element.data);
      posts.add(post);
    });
    return posts;
  }

  static Future<List<Post>> loadPosts() async {
    List<Post> posts = List();
    String uid = await Prefs.loadUserId();

    var querySnapshot = await _firestore
        .collection(folder_users)
        .document(uid)
        .collection(folder_posts)
        .getDocuments();

    querySnapshot.documents.forEach((element) {
      Post post = Post.fromJson(element.data);
      posts.add(post);
    });
    return posts;
  }
}
