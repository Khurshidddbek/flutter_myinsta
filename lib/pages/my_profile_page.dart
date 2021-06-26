import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myinsta/model/post_model.dart';
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

  // demo images
  String img_1 = 'https://ichef.bbci.co.uk/news/640/cpsprodpb/13B1A/production/_106966608_ferrari_verfremdet.jpg';
  String img_2 = 'https://www.formacar.com/storage/images/8/26342/020fc1a3af2bd8c6240ff6ff81da86c003.jpg';

  @override
  void initState() {
    super.initState();

    items.addAll([
      Post(img_1, 'This is demo caption, this first demo caption, This is demo caption, this first demo caption, This is demo caption, this first demo caption, This is demo caption, this first demo caption'),
      Post(img_2, 'This is demo caption, this first demo caption, This is demo caption, this first demo caption, This is demo caption, this first demo caption, This is demo caption, this first demo caption'),
      Post(img_1, 'This is demo caption, this first demo caption, This is demo caption, this first demo caption, This is demo caption, this first demo caption, This is demo caption, this first demo caption'),
      Post(img_2, 'This is demo caption, this first demo caption, This is demo caption, this first demo caption, This is demo caption, this first demo caption, This is demo caption, this first demo caption'),
    ]);
  }

  // Image Picker
  // ===========================================================================
  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
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
        }
    );
  }
  // ===========================================================================


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
      body: Container(
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
                    border: Border.all(
                      color: Color(0xffFCAF45),
                      width: 1.5
                    )
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: _image == null ? Image(
                      height: 70,
                      width: 70,
                      image: AssetImage('assets/images/ic_profile.png'),
                      fit: BoxFit.cover,
                    ) : Image.file(_image, height: 70, width: 70, fit: BoxFit.cover,)
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
                      IconButton(icon: Icon(Icons.add_circle, color: Color(0xffFCAF45),), onPressed: () {
                        _showPicker(context);
                      }),
                    ],
                  ),
                )
              ],
            ),

            // FullName
            Text('Xurshidbek Sobirov'.toUpperCase(), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),),

            SizedBox(height: 5,),

            // FullName
            Text('khurshidddbek@gmail.com', style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.normal),),

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
                          Text('363', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),),

                          SizedBox(height: 3,),

                          Text('POSTS', style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.normal),),
                        ],
                      ),
                    )
                  ),

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
                          Text('168', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),),

                          SizedBox(height: 3,),

                          Text('FOLLOWERS', style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.normal),),
                        ],
                      ),
                    )
                  ),

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
                          Text('156', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),),

                          SizedBox(height: 3,),

                          Text('FOLLOWING', style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.normal),),
                        ],
                      ),
                    )
                  ),
                ],
              ),
            ),

            // Buttons : GridView || ListView
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Button : GridView
                IconButton(
                  icon: Icon(Icons.grid_view, color: Colors.black,),
                  onPressed: () {
                    setState(() {
                      _listView = false;
                    });
                  },
                ),

                // Button : ListView
                IconButton(
                  icon: Icon(Icons.list_alt, color: Colors.black,),
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
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: _listView ? 1 : 2),
                itemCount: items.length,
                itemBuilder: (ctx, i) {
                  return _itemOfPost(items[i]);
                },
              ),
            ),
          ],
        ),
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
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),

          SizedBox(height: 3,),

          // Caption
          Text(post.caption, maxLines: 2, style: TextStyle(color: Colors.black45, fontSize: 16),)
        ],
      ),
    );
  }
}
