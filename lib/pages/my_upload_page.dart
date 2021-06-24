import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyUploadPage extends StatefulWidget {
  static final String id = 'my_upload_page';

  const MyUploadPage({Key key}) : super(key: key);

  @override
  _MyUploadPageState createState() => _MyUploadPageState();
}

class _MyUploadPageState extends State<MyUploadPage> {
  // values
  var _captionController = TextEditingController();
  File _image;

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

  _uploadNewPost() {
    String _caption = _captionController.text.toString();

    if (_caption.isEmpty || _image == null) return ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Upload', style: TextStyle(color: Colors.black, fontSize: 25, fontFamily: 'Billabong'),),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.post_add, color: Color(0xffFCAF45), size: 25,), onPressed: () {})
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Button : add a photo
              GestureDetector(
                onTap: () {
                  _showPicker(context);
                },
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width,
                  color: Colors.grey.withOpacity(0.4),
                  child: _image == null ? Icon(Icons.add_a_photo, color: Colors.grey, size: 60,) :
                      Stack(
                        children: [
                          // Added photo
                          Container(
                            height: double.infinity,
                            width: double.infinity,
                            child: Image.file(_image, fit: BoxFit.cover,),
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
                                IconButton(icon: Icon(Icons.highlight_remove, color: Colors.white,), onPressed: () {
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
            ],
          ),
        ),
      ),
    );
  }
}
