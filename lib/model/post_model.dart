class Post {
  String uid;
  String fullName;
  String imgUser;
  String id;
  String postImage;
  String caption;
  String date;
  bool liked = false;

  bool mine = false;

  Post({this.postImage, this.caption});

  Post.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        fullName = json['fullName'],
        imgUser = json['imgUser'],
        id = json['id'],
        postImage = json['postImage'],
        caption = json['caption'],
        date = json['date'],
        liked = json['liked'];

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'fullName': fullName,
        'imgUser': imgUser,
        'id': id,
        'postImage': postImage,
        'caption': caption,
        'date': date,
        'liked': liked,
      };
}
