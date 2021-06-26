import 'package:flutter/material.dart';
import 'package:flutter_myinsta/model/user_model.dart';

class MySearchPage extends StatefulWidget {
  static final String id = 'my_search_page';

  const MySearchPage({Key key}) : super(key: key);

  @override
  _MySearchPageState createState() => _MySearchPageState();
}

class _MySearchPageState extends State<MySearchPage> {
  // values
  var _searchController = TextEditingController();
  List<User> users = [];

  @override
  void initState() {
    super.initState();

    users.addAll([
      User('Xurshidbek Sobirov', 'khurshidddbek@gmail.com'),
      User('Xurshidbek Sobirov', 'khurshidddbek@gmail.com'),
      User('Xurshidbek Sobirov', 'khurshidddbek@gmail.com'),
      User('Xurshidbek Sobirov', 'khurshidddbek@gmail.com'),
      User('Xurshidbek Sobirov', 'khurshidddbek@gmail.com'),
      User('Xurshidbek Sobirov', 'khurshidddbek@gmail.com'),
      User('Xurshidbek Sobirov', 'khurshidddbek@gmail.com'),
      User('Xurshidbek Sobirov', 'khurshidddbek@gmail.com'),
      User('Xurshidbek Sobirov', 'khurshidddbek@gmail.com'),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Search', style: TextStyle(color: Colors.black,fontSize: 25, fontFamily: 'Billabong'),),
        centerTitle: true,
      ),
      body: Container(
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
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 15,),
                  icon: Icon(Icons.search, color: Colors.grey,),
                  border: InputBorder.none
                ),
              ),
            ),

            SizedBox(height: 10,),

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
              child: Image(
                height: 45,
                width: 45,
                image: AssetImage('assets/images/ic_profile.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(width: 5,),

          // FullName || Email
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // FullName
              Text(user.fullName, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),),

              SizedBox(height: 5,),

              // FullName
              Text(user.email, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal, fontSize: 14),),
            ],
          ),

          // Button : Follow
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 30,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.4),
                    ),
                  ),
                  child: Center(
                    child: Text('Follow', style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.bold),),
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