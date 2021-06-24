import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_myinsta/model/post_model.dart';

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

  // demo images
  String img_1 = 'https://ichef.bbci.co.uk/news/640/cpsprodpb/13B1A/production/_106966608_ferrari_verfremdet.jpg';
  String img_2 = 'https://www.formacar.com/storage/images/8/26342/020fc1a3af2bd8c6240ff6ff81da86c003.jpg';

  @override
  void initState() {
    super.initState();

    items.addAll([
      Post(img_1, 'This is demo caption, this first demo caption, This is demo caption, this first demo caption, This is demo caption, this first demo caption, This is demo caption, this first demo caption'),
      Post(img_2, 'This is demo caption, this first demo caption, This is demo caption, this first demo caption, This is demo caption, this first demo caption, This is demo caption, this first demo caption'),
    ]);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Instagram', style: TextStyle(color: Colors.black,fontSize: 25, fontFamily: 'Billabong'),),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              widget.pageController.animateToPage(2, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
            },
            icon: Icon(Icons.camera_alt, color: Colors.black,),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (ctx, index) {
          return _postOfItems(items[index]);
        },
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

                    SizedBox(width: 10,),

                    // Username || Data
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Username', style: TextStyle(color: Colors.black),),

                        Text('February 2, 2021', style: TextStyle(color: Colors.grey),),
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
            imageUrl: post.postImage,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),

          // Buttons : Like || Share
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(FontAwesome.heart_o),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(FontAwesome.send),
              ),
            ],
          ),

          // Caption
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: RichText(
              softWrap: true,
              overflow: TextOverflow.visible,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: " " + post.caption,
                    style: TextStyle(color: Colors.black),
                  )
                ]
              ),
            ),
          ),
        ],
      ),
    );
  }
}
