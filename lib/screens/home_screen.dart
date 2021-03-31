import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:working_with_apis/components/post_item.dart';
import 'package:working_with_apis/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:working_with_apis/models/post.dart';
import 'package:working_with_apis/models/user.dart';
import 'package:working_with_apis/screens/login_screen.dart';
import 'package:working_with_apis/screens/new_post_screen.dart';
import 'package:working_with_apis/screens/post_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String url = '$mainUrl/api/post/all/';
  String token;
  Map args;
  User user;

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    // token = args['token'];
    user = args['user'];
    print('In homeScreen, user is: ${user.firstName} ${user.lastName} \n '
        'with token: ${user.token}');
    token = user.token;

    _refresher() async {
      setState(() {});
      return true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(icon: Icon(Icons.exit_to_app), onPressed: (){
            logOut();
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            NewPostScreen.id,
            arguments: {
              'user': user,
            },
          );
        },
        child: Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return _refresher();
        },
        child: FutureBuilder(
          future: http.get(
            Uri.parse(url),
            headers: {HttpHeaders.authorizationHeader: token},
          ),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              http.Response response = snapshot.data;
              var jsonResponse;
              print(response.body);
              if (response.statusCode < 300) {
                jsonResponse = convert.jsonDecode(response.body);
                // jsonResponse = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
                List<Post> postList = [];
                int count = 0;
                for (Map map in jsonResponse) {
                  count++;
                  Post post = Post.fromMap(map);
                  postList.add(post);
                }
                if (count == 0) {
                  return Center(
                    child: Text('Posts not found !!!'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: count,
                    itemBuilder: (context, index) {
                      return PostItem(
                        postList[index],
                        () {
                          onTapped(postList[index]);
                        },
                      );
                    },
                  );
                }
              } else {
                return Center(
                  child: Text(
                    'An Error happened',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                );
              }
              return SizedBox();
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  void onTapped(Post post) {
    Navigator.pushNamed(
      context,
      PostDetailScreen.id,
      arguments: {
        'user': user,
        'post_id': post.postId,
        'post': post,
      },
    );
  }

  void logOut() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.popAndPushNamed(context, LoginScreen.id);
  }

}
