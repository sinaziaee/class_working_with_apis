import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:working_with_apis/constants.dart';

class PostDetailScreen extends StatefulWidget {
  static String id = 'post_detail_screen';
  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  String title, description, datetime, sender;

  String url = '$mainUrl/api/post';
  Map args;
  String token, postId;

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    postId = args['post_id'];
    token = args['token'];
    return FutureBuilder(
        future: http.get(
          Uri.parse('$url/$postId'),
          headers: {
            HttpHeaders.authorizationHeader: token,
          },
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            http.Response response = snapshot.data;
            if (response.statusCode < 400) {
              var jsonResponse =
                  convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
              title = jsonResponse['title'];
              description = jsonResponse['description'];
              datetime = jsonResponse['datetime'];
              sender = jsonResponse['sender'];
              return Scaffold(
                appBar: AppBar(
                  title: Text(title ?? 'Title'),
                  actions: [
                    Text(
                      datetime,
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      getText('Post by $sender', 20, 20),
                      getText(description, 30, 17),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: Container(
                  child: Text('Message not found !!!'),
                ),
              );
            }
          } else {
            return CircularProgressIndicator();
          }
        });
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
