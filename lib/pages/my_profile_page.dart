import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myinsta/model/post_model.dart';
import 'package:flutter_myinsta/model/user_model.dart';
import 'package:flutter_myinsta/services/auth_service.dart';
import 'package:flutter_myinsta/services/data_service.dart';
import 'package:flutter_myinsta/services/file_service.dart';
import 'package:flutter_myinsta/services/utils_service.dart';
import 'package:image_picker/image_picker.dart';

class MyProfilePage extends StatefulWidget {
  static final String id = 'my_profile_page';

  const MyProfilePage({Key key}) : super(key: key);

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  // values
  List<Post> items = [];
  bool _listView = true;
  File _image;
  bool isLoading = false;
  int count_posts = 0, countFollowers = 0, countFollowing = 0;

  String fullName = '', email = '', imgUrl = '';

  @override
  void initState() {
    super.initState();

    _apiLoadUser();
    _apiLoadPosts();
  }

  // Image Picker
  // ===========================================================================
  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });

    _apiChangePhoto();
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });

    _apiChangePhoto();
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Pick Photo'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Take Photo'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
  // ===========================================================================

  _apiLoadUser() {
    setState(() {
      isLoading = true;
    });

    DataService.loadUser().then((value) => {
          _showUserInfo(value),
        });
  }

  _showUserInfo(User user) {
    setState(() {
      this.fullName = user.fullName;
      this.email = user.email;
      this.imgUrl = user.imgUrl;
      this.countFollowers = user.followersCount;
      this.countFollowing = user.followingCount;
      isLoading = false;
    });
  }

  _apiChangePhoto() {
    setState(() {
      isLoading = true;
    });

    if (_image == null) return;

    FileService.uploadUserImage(_image).then((downloadUrl) => {
          _apiUpdateUser(downloadUrl),
        });
  }

  _apiUpdateUser(String downloadUrl) async {
    setState(() {
      isLoading = false;
    });

    User user = await DataService.loadUser();

    user.imgUrl = downloadUrl;

    await DataService.updateUser(user);
    _apiLoadUser();
  }

  _apiLoadPosts() {
    DataService.loadPosts().then((value) => {_resLoadPosts(value)});
  }

  _resLoadPosts(List<Post> posts) {
    setState(() {
      items = posts;
      count_posts = items.length;
    });
  }

  _actionLogout() async {
    if (await Utils.commonDialog(context, 'Logout?', 'Do you want to logout?', false)) {
      AuthService.signOutUser(context);
    }
  }

  _actionRemovePost(Post post) async {
    if (await Utils.commonDialog(context, 'Logout?', 'Do you want to logout?', false)) {
      setState(() {
        isLoading = true;
      });

      DataService.removePost(post).then((value) => {
        _apiLoadPosts(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontFamily: 'Billabong'),
        ),
        centerTitle: true,
        actions: [
          // Button : Logout
          IconButton(
            onPressed: () {
              _actionLogout();
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Color(0xffFCAF45),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                // Edit Profile image
                Stack(
                  children: [
                    // Profile Image
                    Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70),
                          border:
                              Border.all(color: Color(0xffFCAF45), width: 1.5)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: imgUrl == null || imgUrl.isEmpty
                            ? Image(
                                image:
                                    AssetImage("assets/images/ic_profile.png"),
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                imgUrl,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),

                    // Button : Edit Profile image
                    Container(
                      height: 92,
                      width: 92,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.add_circle,
                                color: Color(0xffFCAF45),
                              ),
                              onPressed: () {
                                _showPicker(context);
                              }),
                        ],
                      ),
                    )
                  ],
                ),

                // FullName
                Text(
                  fullName.toUpperCase(),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),

                SizedBox(
                  height: 5,
                ),

                // FullName
                Text(
                  email,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                ),

                // POSTS || FOLLOWERS || FOLLOWING
                Container(
                  height: 80,
                  width: double.infinity,
                  child: Row(
                    children: [
                      // POSTS
                      Expanded(
                          child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              count_posts.toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              'POSTS',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      )),

                      Container(
                        height: 20,
                        width: 1,
                        color: Colors.grey.withOpacity(0.6),
                      ),

                      // FOLLOWERS
                      Expanded(
                          child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              countFollowers.toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              'FOLLOWERS',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      )),

                      Container(
                        height: 20,
                        width: 1,
                        color: Colors.grey.withOpacity(0.6),
                      ),

                      // FOLLOWING
                      Expanded(
                          child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              countFollowing.toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              'FOLLOWING',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),

                // Buttons : GridView || ListView
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Button : GridView
                    IconButton(
                      icon: Icon(
                        Icons.grid_view,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _listView = false;
                        });
                      },
                    ),

                    // Button : ListView
                    IconButton(
                      icon: Icon(
                        Icons.list_alt,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _listView = true;
                        });
                      },
                    ),
                  ],
                ),

                // Posts
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _listView ? 1 : 2),
                    itemCount: items.length,
                    itemBuilder: (ctx, i) {
                      return _itemOfPost(items[i]);
                    },
                  ),
                ),
              ],
            ),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox.shrink()
        ],
      ),
    );
  }

  Widget _itemOfPost(Post post) {
    return GestureDetector(
      onLongPress: () {
        _actionRemovePost(post);
      },
      child: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            // Post image
            Expanded(
              child: CachedNetworkImage(
                width: double.infinity,
                imageUrl: post.postImage,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),

            SizedBox(
              height: 3,
            ),

            // Caption
            Container(
              width: double.infinity,
              child: Text(
                post.caption,
                maxLines: 2,
                style: TextStyle(color: Colors.black45, fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}
