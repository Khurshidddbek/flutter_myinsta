import 'package:flutter/material.dart';
import 'package:flutter_myinsta/model/user_model.dart';
import 'package:flutter_myinsta/services/data_service.dart';
import 'package:flutter_myinsta/services/http_service.dart';

class MySearchPage extends StatefulWidget {
  static final String id = 'my_search_page';

  const MySearchPage({Key key}) : super(key: key);

  @override
  _MySearchPageState createState() => _MySearchPageState();
}

class _MySearchPageState extends State<MySearchPage> {
  // values
  var _searchController = TextEditingController();
  List<User> users = List();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _apiSearchUsers("");
  }

  _apiSearchUsers(String keyword) {
    setState(() {
      isLoading = true;
    });

    DataService.searchUsers(keyword).then((respUsers) => {
          _respSearchUsers(respUsers),
        });
  }

  _respSearchUsers(List<User> respUsers) {
    setState(() {
      users = respUsers;
      isLoading = false;
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Search',
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontFamily: 'Billabong'),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                // TextField : Search
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.grey.withOpacity(0.4),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: Colors.black87),
                    onChanged: (input) {
                      _apiSearchUsers(input);
                    },
                    decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                        icon: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        border: InputBorder.none),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                // Users
                Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (ctx, i) {
                      return _itemsOfList(users[i]);
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

  Widget _itemsOfList(User user) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          // Profile Image
          Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(70),
              border: Border.all(
                color: Color(0xffFCAF45),
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22.5),
              child: user.imgUrl == null || user.imgUrl.isEmpty
                  ? Image(
                      image: AssetImage("assets/images/ic_profile.png"),
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      user.imgUrl,
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover,
                    ),
            ),
          ),

          SizedBox(
            width: 5,
          ),

          // FullName || Email
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // FullName
              Text(
                user.fullName,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),

              SizedBox(
                height: 5,
              ),

              // Email
              Text(
                user.email,
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                    fontSize: 14),
              ),
            ],
          ),

          // Button : Follow
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    if (user.followed) {
                      _apiUnfollowUser(user);
                    } else {
                      _apiFollowUser(user);
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
                        user.followed ? 'Followed' : 'Follow',
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
        ],
      ),
    );
  }
}
