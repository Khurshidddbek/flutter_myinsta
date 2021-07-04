class User {
  String uid = '';
  String fullName = '';
  String email = '';
  String password = '';
  String imgUrl = '';

  bool followed = false;
  int followersCount = 0;
  int followingCount = 0;

  User({this.fullName, this.email, this.password});

  User.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        fullName = json['fullName'],
        email = json['email'],
        password = json['password'],
        imgUrl = json['imgUrl'];

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'fullName': fullName,
        'email': email,
        'password': password,
        'imgUrl': imgUrl,
      };
}
