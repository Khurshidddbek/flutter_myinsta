import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_myinsta/model/post_model.dart';
import 'package:flutter_myinsta/services/data_service.dart';

class MyLikesPage extends StatefulWidget {
  static final String id = 'my_likes_page';

  const MyLikesPage({Key key}) : super(key: key);

  @override
  _MyLikesPageState createState() => _MyLikesPageState();
}

class _MyLikesPageState extends State<MyLikesPage> {
  // values
  List<Post> items = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _apiLoadLikes();
  }

  _apiLoadLikes() {
    setState(() {
      isLoading = true;
    });

    DataService.loadLikes().then((value) => {
          _resLoadLikes(value),
        });
  }

  _resLoadLikes(List<Post> posts) {
    setState(() {
      items = posts;
      isLoading = false;
    });
  }

  _apiPostUnLike(Post post) {
    setState(() {
      isLoading = true;
      post.liked = false;
    });

    DataService.likePost(post, false).then((value) => {
          _apiLoadLikes(),
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Likes',
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontFamily: 'Billabong'),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          items.length > 0
              ? ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (ctx, index) {
                    return _postOfItems(items[index]);
                  },
                )
              : Center(
                  child: Text('No liked posts'),
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
                      borderRadius: BorderRadius.circular(40),
                      child: Image(
                        height: 40,
                        width: 40,
                        image: AssetImage('assets/images/ic_profile.png'),
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
                          'Username',
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          'February 2, 2021',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),

                // Button : More (Options)
                IconButton(
                  onPressed: () {},
                  icon: Icon(SimpleLineIcons.options),
                ),
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

          // Buttons : UnLike || Share
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (post.liked) {
                    _apiPostUnLike(post);
                  }
                },
                icon: !post.liked
                    ? Icon(FontAwesome.heart_o)
                    : Icon(
                        FontAwesome.heart,
                        color: Colors.red,
                      ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(FontAwesome.send),
              ),
            ],
          ),

          // Caption
          Container(
            width: double.infinity,
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
