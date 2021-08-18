import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myinsta/model/post_model.dart';
import 'package:flutter_myinsta/model/user_model.dart';
import 'package:flutter_myinsta/services/data_service.dart';
import 'package:flutter_myinsta/services/http_service.dart';

class SomeoneProfilePage extends StatefulWidget {
  static final String id = 'someone_Profile_Page';

  String uid;
  SomeoneProfilePage({Key key, this.uid}) : super(key: key);

  @override
  _SomeoneProfilePageState createState() => _SomeoneProfilePageState();
}

class _SomeoneProfilePageState extends State<SomeoneProfilePage> {
  // values
  List<Post> items = [];
  bool _listView = true;
  bool isLoading = false;
  int count_posts = 0, countFollowers = 0, countFollowing = 0;

  String fullName = '', email = '', imgUrl = '';
  User someoneUser;

  @override
  void initState() {
    super.initState();

    _apiLoadUser();
    _apiLoadPosts();
  }

  _apiLoadUser() {
    setState(() {
      isLoading = true;
    });

    DataService.loadUser(id: widget.uid).then((value) => {
      _showUserInfo(value),
    });
  }

  _showUserInfo(User user) {
    setState(() {
      someoneUser = user;
      this.fullName = user.fullName;
      this.email = user.email;
      this.imgUrl = user.imgUrl;
      this.countFollowers = user.followersCount;
      this.countFollowing = user.followingCount;
      isLoading = false;
    });
  }

  _apiLoadPosts() {
    DataService.loadPosts(id: widget.uid).then((value) => {_resLoadPosts(value)});
  }

  _resLoadPosts(List<Post> posts) {
    setState(() {
      items = posts;
      count_posts = items.length;
    });
  }


  // Follow action
  _apiFollowUser(User someone) async {
    setState(() {
      isLoading = true;
    });

    await DataService.followUser(someone);

    setState(() {
      someone.followed = true;
      isLoading = false;
    });

    DataService.storePostsToMyFeed(someone);

    // Notification
    String username = '';
    DataService.loadUser().then((userMe) {
      username = userMe.fullName;
    });

    Map<String, dynamic> params = HttpService.paramCreate(username, someone.deviceToken);
    HttpService.POST(params);


    _apiLoadUser();
  }

  _apiUnfollowUser(User someone) async {
    setState(() {
      isLoading = true;
    });

    await DataService.unfollowUser(someone);

    setState(() {
      someone.followed = false;
      isLoading = false;
    });

    DataService.removePostsFromMyFeed(someone);


    _apiLoadUser();
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
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                // Profile image
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

                SizedBox(height: 10,),


                // Button : Follow
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (someoneUser.followed) {
                            _apiUnfollowUser(someoneUser);
                          } else {
                            _apiFollowUser(someoneUser);
                          }
                        },
                        child: Container(
                          height: 30,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              someoneUser.followed ? 'Followed' : 'Follow',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
    return Container(
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
    );
  }
}
