import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:working_with_apis/constants.dart';
import 'package:working_with_apis/models/post.dart';
import 'package:working_with_apis/models/user.dart';

class PostDetailScreen extends StatefulWidget {
  static String id = 'post_detail_screen';

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  // String title, description, datetime, sender;

  String url = '$mainUrl/api/post';
  Map args;
  int postId;
  User user;

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    postId = args['post_id'];
    user = args['user'];
    print('url: $url/$postId');
    return FutureBuilder(
      future: http.get(
        Uri.parse('$url/?post_id=$postId'),
        headers: {
          HttpHeaders.authorizationHeader: user.token,
        },
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          http.Response response = snapshot.data;
          print('------------------------------------');
          print(response.body);
          if (response.statusCode < 400) {
            var jsonResponse =
                convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
            Post post = Post.fromMap(jsonResponse);
            return Scaffold(
              appBar: AppBar(
                title: Text('Post Detail Screen'),
                actions: [
                  Text(
                    post.dateTime.toString().substring(0,10),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    getText(post.title, 30, 25),
                    SizedBox(
                      height: 50,
                    ),
                    getText('Post by ${post.sender}', 20, 20),
                    SizedBox(
                      height: 20,
                    ),
                    getText(post.description, 30, 17),
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text('Post Detail Screen'),
              ),
              body: Center(
                child: Container(
                  child: Text('Post not found !!!'),
                ),
              ),
            );
          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget getText(String data, double horizontal, double size) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontal,
      ),
      child: Text(
        data,
        style: TextStyle(
          color: Colors.black,
          fontSize: size,
        ),
      ),
    );
  }
}
