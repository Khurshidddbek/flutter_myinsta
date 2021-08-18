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
  static String folder_following = "following";
  static String folder_followers = "followers";

  // User Related
  static Future storeUser(User user) async {
    user.uid = await Prefs.loadUserId();

    Map<String, String> params = await Utils.deviceParams();

    print(params.toString());

    user.deviceId = params['device_id'];
    user.deviceType = params['device_type'];
    user.deviceToken = params['device_token'];

    final instance = Firestore.instance;
    return instance
        .collection('users')
        .document(user.uid)
        .setData(user.toJson());
  }

  static Future<User> loadUser({String id}) async {
    String uid = await Prefs.loadUserId();

    if (id != null) uid = id;

    final instance = Firestore.instance;

    var value = await _firestore.collection(folder_users).document(uid).get();

    User user = User.fromJson(value.data);

    var querySnapshot1 = await _firestore.collection(folder_users).document(uid).collection(folder_followers).getDocuments();
    user.followersCount = querySnapshot1.documents.length;

    var querySnapshot2 = await _firestore.collection(folder_users).document(uid).collection(folder_following).getDocuments();
    user.followingCount = querySnapshot2.documents.length;

    return user;
  }

  static Future updateUser(User user) async {
    String uid = await Prefs.loadUserId();
    final instance = Firestore.instance;
    return instance.collection(folder_users).document(uid).updateData(user.toJson());
  }

  static Future<List<User>> searchUsers(String keyword) async {
    List<User> users = List();
    String uid = await Prefs.loadUserId();

    final instance = Firestore.instance;

    var querySnapshot = await _firestore
        .collection(folder_users)
        .orderBy('email')
        .startAt([keyword]).getDocuments();

    querySnapshot.documents.forEach((user) {
      User respUser = User.fromJson(user.data);

      if (respUser.uid != uid) users.add(respUser);
    });

    List<User> following = List();

    var querySnapshot2 = await _firestore.collection(folder_users).document(uid).collection(folder_following).getDocuments();

    querySnapshot2.documents.forEach((element) {
      following.add(User.fromJson(element.data));
    });

    for (User user in users) {
      if (following.contains(user)) {
        user.followed = true;
      } else {
        user.followed = false;
      }
    }

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
        .collection(folder_feeds)
        .getDocuments();

    querySnapshot.documents.forEach((element) {
      Post post = Post.fromJson(element.data);
      if (post.uid == uid) post.mine = true;
      posts.add(post);
    });
    return posts;
  }

  static Future<List<Post>> loadPosts({String id}) async {
    List<Post> posts = List();
    String uid = await Prefs.loadUserId();

    if (id != null) uid = id;

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


  // Like || Unlike
  static Future<Post> likePost(Post post, bool liked) async {
    String uid = await Prefs.loadUserId();
    post.liked = liked;

    await _firestore.collection(folder_users).document(uid).collection(folder_feeds).document(post.id).setData(post.toJson());

    if (uid == post.uid) {
      await _firestore.collection(folder_users).document(uid).collection(folder_posts).document(post.id).setData(post.toJson());
    }
  }

  static Future<List<Post>> loadLikes() async {
    String uid = await Prefs.loadUserId();
    List<Post> posts = List();

    var querySnapshot = await _firestore.collection(folder_users).document(uid).collection(folder_feeds).where('liked', isEqualTo: true).getDocuments();

    querySnapshot.documents.forEach((result) {
      Post post = Post.fromJson(result.data);

      if (post.uid == uid) post.mine = true;

      posts.add(post);
    });

    return posts;
  }


  // Follow actions
  static Future<User> followUser(User someone) async {
    User me = await loadUser();

    // I followed to someone
    await _firestore.collection(folder_users).document(me.uid).collection(folder_following).document(someone.uid).setData(someone.toJson());

    // I am in someone's followers
    await _firestore.collection(folder_users).document(someone.uid).collection(folder_followers).document(me.uid).setData(me.toJson());

    return someone;
  }

  static Future<User> unfollowUser(User someone) async {
    User me = await loadUser();

    // I unfollowed to someone
    await _firestore.collection(folder_users).document(me.uid).collection(folder_following).document(someone.uid).delete();

    // I am not in someone's followers
    await _firestore.collection(folder_users).document(someone.uid).collection(folder_followers).document(me.uid).delete();

    return someone;
  }

  static Future storePostsToMyFeed(User someone) async {
    // Store someone posts to my feed

    List<Post> posts = List();

    var querySnapshot = await _firestore.collection(folder_users).document(someone.uid).collection(folder_posts).getDocuments();

    querySnapshot.documents.forEach((element) {
      var post = Post.fromJson(element.data);

      post.liked = false;
      posts.add(post);
    });

    for (Post post in posts) {
      storeFeed(post);
    }
  }

  static Future removePostsFromMyFeed(User someone) async {
    // Remove someone's posts from my feed

    List<Post> posts = List();

    var querySnapshot = await _firestore.collection(folder_users).document(someone.uid).collection(folder_posts).getDocuments();

    querySnapshot.documents.forEach((element) {
      var post = Post.fromJson(element.data);

      posts.add(post);
    });

    for (Post post in posts) {
      removeFeed(post);
    }
  }

  static Future removeFeed(Post post) async {
    String uid = await Prefs.loadUserId();

    return await _firestore.collection(folder_users).document(uid).collection(folder_feeds).document(post.id).delete();
  }

  static Future removePost(Post post) async {
    String uid = await Prefs.loadUserId();

    await removeFeed(post);

    return await _firestore.collection(folder_users).document(uid).collection(folder_posts).document(post.uid).delete();
  }
}