import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_myinsta/services/prefs_service.dart';

class FileService {
  static final _storage = FirebaseStorage.instance.ref();
  static final folder_post = 'post_images';
  static final folder_user = 'user_images';

  static Future<String> uploadUserImage(File _image) async {
    String uid = await Prefs.loadUserId();

    String imgName = uid;

    StorageReference firebaseStorageRef =
        _storage.child(folder_user).child(imgName);

    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);

    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

    if (taskSnapshot != null) {
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    }
    return null;
  }

  static Future<String> uploadPostImage(File _image) async {
    String uid = await Prefs.loadUserId();

    String imgName = uid + "_" + DateTime.now().toString();

    StorageReference firebaseStorageRef =
        _storage.child(folder_post).child(imgName);

    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);

    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

    if (taskSnapshot != null) {
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    }
    return null;
  }
}
