import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_myinsta/model/post_model.dart';
import 'package:flutter_myinsta/services/data_service.dart';
import 'package:flutter_myinsta/services/utils_service.dart';

import '../model/post_model.dart';

class MyFeedPage extends StatefulWidget {
  static final String id = 'my_feed_page';

  PageController pageController;
  MyFeedPage(this.pageController);

  @override
  _MyFeedPageState createState() => _MyFeedPageState();
}

class _MyFeedPageState extends State<MyFeedPage> {
  // values
  List<Post> items = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _apiLoadFeeds();
  }

  _apiLoadFeeds() {
    setState(() {
      isLoading = true;
    });

    DataService.loadFeeds().then((posts) => {_resLoadFeeds(posts)});
  }

  _resLoadFeeds(List<Post> posts) {
    setState(() {
      items = posts;
      isLoading = false;
    });
  }

  // Like || Unlike actions
  // ===========================================================================
  _apiPostLike(Post post) async {
    setState(() {
      isLoading = true;
    });

    await DataService.likePost(post, true);

    setState(() {
      isLoading = false;
      post.liked = true;
    });
  }

  _apiPostUnlike(Post post) async {
    setState(() {
      isLoading = true;
    });

    await DataService.likePost(post, false);

    setState(() {
      isLoading = false;
      post.liked = true;
    });
  }
  // ===========================================================================

  _actionRemovePost(Post post) async {
    if (await Utils.commonDialog(context, 'Logout?', 'Do you want to logout?', false)) {
      setState(() {
        isLoading = true;
      });

      DataService.removePost(post).then((value) => {
        _apiLoadFeeds(),
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
          'Instagram',
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontFamily: 'Billabong'),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              widget.pageController.animateToPage(2,
                  duration: Duration(milliseconds: 200), curve: Curves.easeIn);
            },
            icon: Icon(
              Icons.camera_alt,
              color: Color(0xffFCAF45),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          items.length != 0 ?
          ListView.builder(
            itemCount: items.length,
            itemBuilder: (ctx, index) {
              return _postOfItems(items[index]);
            },
          ) : Center(child: Text('No posts'),),

          isLoading ? Center(child: CircularProgressIndicator(),) : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _postOfItems(Post post) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Divider(),

          // Profile information
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Profile information
                Row(
                  children: [
                    // Profile image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(22.5),
                      child: post.imgUser == null || post.imgUser.isEmpty
                          ? Image(
                              image: AssetImage("assets/images/ic_profile.png"),
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              post.imgUser,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                    ),

                    SizedBox(
                      width: 10,
                    ),

                    // Username || Data
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.fullName,
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          post.date,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),

                // Button : More (Options)
                post.mine ?
                IconButton(
                  onPressed: () {
                    _actionRemovePost(post);
                  },
                  icon: Icon(SimpleLineIcons.options),
                ) : SizedBox.shrink(),
              ],
            ),
          ),

          // Post image
          CachedNetworkImage(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            imageUrl: post.postImage,
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),

          // Buttons : Like || Share
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (!post.liked) {
                    _apiPostLike(post);
                  } else {
                    _apiPostUnlike(post);
                  }
                },
                icon: !post.liked ? Icon(FontAwesome.heart_o) : Icon(FontAwesome.heart, color: Colors.red,),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.share_outlined),
              ),
            ],
          ),

          // Caption
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: RichText(
              softWrap: true,
              overflow: TextOverflow.visible,
              text: TextSpan(children: [
                TextSpan(
                  text: " " + post.caption,
                  style: TextStyle(color: Colors.black),
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
