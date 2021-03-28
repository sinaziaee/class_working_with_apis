import 'dart:io';

import 'package:flutter/material.dart';
import 'package:working_with_apis/components/post_item.dart';
import 'package:working_with_apis/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:working_with_apis/models/post.dart';
import 'package:working_with_apis/models/user.dart';
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
    print('---------------------------------------------');
    args = ModalRoute.of(context).settings.arguments;
    // token = args['token'];
    user = args['user'];
    token = user.token;
    print(token);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: http.get(
          Uri.parse(url),
          headers: {HttpHeaders.authorizationHeader: token},
        ),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            http.Response response = snapshot.data;
            var jsonResponse;
            if (response.statusCode < 400) {
              jsonResponse = convert.jsonDecode(response.body);
              // jsonResponse = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
              List<Post> postList = [];
              int count = 0;
              // print(jsonResponse);
              for (Map map in jsonResponse) {
                count++;
                Post post = Post.fromJson(map);
                postList.add(post);
              }
              if (count == 0) {
                return Center(
                  child: Text('Posts not found !!!'),
                );
              } else {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return PostItem(
                      postList[index],
                      () {
                        onTapped(postList[index], index);
                      },
                    );
                  },
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return SizedBox();
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  void onTapped(Post post, int index) {
    Navigator.pushNamed(context, PostDetailScreen.id);
  }
}
