import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_myinsta/model/post_model.dart';
import 'package:flutter_myinsta/services/data_service.dart';
import 'package:flutter_myinsta/services/file_service.dart';
import 'package:image_picker/image_picker.dart';

class MyUploadPage extends StatefulWidget {
  static final String id = 'my_upload_page';

  PageController pageController;
  MyUploadPage(this.pageController);

  @override
  _MyUploadPageState createState() => _MyUploadPageState();
}

class _MyUploadPageState extends State<MyUploadPage> {
  // values
  var _captionController = TextEditingController();
  File _image;
  bool isLoading = false;

  // Image Picker
  // ===========================================================================
  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

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
        });
  }
  // ===========================================================================

  _uploadNewPost() {
    String _caption = _captionController.text.toString();
    if (_caption.isEmpty || _image == null) return;

    // Send post to server
    _apiPostImage();
  }

  _apiPostImage() {
    setState(() {
      isLoading = true;
    });

    FileService.uploadPostImage(_image).then((downloadUrl) => {
          _resPostImage(downloadUrl),
        });
  }

  _resPostImage(String downloadUrl) {
    String caption = _captionController.text.toString().trim();
    Post post = Post(postImage: downloadUrl, caption: caption);
    _apiStorePost(post);
  }

  _apiStorePost(Post post) async {
    // Post to posts
    Post posted = await DataService.storePost(post);

    // Post to feeds
    DataService.storeFeed(post).then((value) => {_moveToFeed()});
  }

  _moveToFeed() {
    _image = null;
    _captionController.text = null;

    setState(() {
      isLoading = false;
    });

    widget.pageController.animateToPage(0,
        duration: Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Upload',
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontFamily: 'Billabong'),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(
                Icons.drive_folder_upload,
                color: Color(0xffFCAF45),
                size: 25,
              ),
              onPressed: _uploadNewPost)
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(children: [
                // Button : add a photo
                GestureDetector(
                  onTap: () {
                    _showPicker(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width,
                    color: Colors.grey.withOpacity(0.4),
                    child: _image == null
                        ? Icon(
                            Icons.add_a_photo,
                            color: Colors.grey,
                            size: 60,
                          )
                        : Stack(
                            children: [
                              // Added photo
                              Container(
                                height: double.infinity,
                                width: double.infinity,
                                child: Image.file(
                                  _image,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              // Button : x => remove added photo
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.black12.withOpacity(0.2),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        icon: Icon(
                                          Icons.highlight_remove,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _image = null;
                                          });
                                        }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                // TextField : Caption
                Container(
                  margin: EdgeInsets.all(10),
                  child: TextField(
                    style: TextStyle(color: Colors.black),
                    controller: _captionController,
                    decoration: InputDecoration(
                      hintText: 'Caption',
                      hintStyle: TextStyle(color: Colors.black38, fontSize: 17),
                    ),
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                  ),
                ),
              ]),
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
