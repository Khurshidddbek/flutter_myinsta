class User {
  String uid = '';
  String fullName = '';
  String email = '';
  String password = '';
  String imgUrl = '';

  String deviceId = '';
  String deviceType = '';
  String deviceToken = '';

  bool followed = false;
  int followersCount = 0;
  int followingCount = 0;

  User({this.fullName, this.email, this.password});

  User.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        fullName = json['fullName'],
        email = json['email'],
        password = json['password'],
        imgUrl = json['imgUrl'],
        deviceId = json['deviceId'],
        deviceType = json['deviceType'],
        deviceToken = json['deviceToken'];

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'fullName': fullName,
        'email': email,
        'password': password,
        'imgUrl': imgUrl,
        'deviceId': deviceId,
        'deviceType': deviceType,
        'deviceToken': deviceToken,
      };

  @override
  bool operator ==(Object other) {
    return (other is User) && other.uid == uid;
  }
  }