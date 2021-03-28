import 'dart:io';

import 'package:flutter/material.dart';
import 'package:working_with_apis/components/confirm_button.dart';
import 'package:working_with_apis/components/custom_dialog.dart';
import 'package:working_with_apis/components/custom_textfield.dart';
import 'package:working_with_apis/models/post.dart';
import 'package:http/http.dart' as http;
import 'package:working_with_apis/models/user.dart';
import 'dart:convert' as convert;
import '../constants.dart';

class NewPostScreen extends StatefulWidget {

  static String id = 'new_post_screen';

  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {

  TextEditingController titleController, descriptionController;
  String url = '$mainUrl/api/post/';
  Size size;
  FocusNode node;

  Map args;
  User user;
  Post post;

  @override
  void initState() {
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    node = FocusScope.of(context);
    args = ModalRoute.of(context).settings.arguments;
    user = args['user'];
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post Screen'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.03,
            ),
            MyTextField(
              size: size,
              hint: "Title",
              node: node,
              isLast: false,
              isPassword: false,
              controller: titleController,
              color: Colors.black,
            ),
            MyTextField(
              hint: "Description",
              node: node,
              isLast: true,
              isPassword: false,
              controller: descriptionController,
              color: Colors.black,
              size: size,
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
            MyConfirmButton(
              size: size,
              text: 'Continue',
              onPressed: () {
                onContinuePressed();
              },
            ),
          ],
        ),
      ),
    );
  }

  onContinuePressed() async {
    if (isValidated()) {
      uploadInfo(post);
    } else {
      // pass
    }
  }

  bool isValidated() {
    String title = titleController.text;
    String description = descriptionController.text;
    if (title.length < 3) {
      _showDialog('Bad Title Format');
      return false;
    } else if (description.length < 3) {
      _showDialog('Bad Description Format');
      return false;
    }

    post = Post(
      title: title,
      description: description,
      dateTime: null,
      sender: '',
    );
    return true;
  }

  _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          size: size,
          color: Colors.black,
          text: ' OK !!!',
          onPressed: () {
            Navigator.pop(context);
          },
          message: message,
        );
      },
    );
  }

  Future<void> uploadInfo(Post post) async {
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        body: convert.jsonEncode(post.toJson()),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          HttpHeaders.authorizationHeader: user.token,
        },
      );
      var jsonResponse;
      print('***************************************************');
      print(response.body);
      print('***************************************************');
      if (response.statusCode < 400) {
        jsonResponse = convert.jsonDecode(response.body);
        _showDialog('Post uploaded successfully');
        titleController.clear();
        descriptionController.clear();
        setState(() {

        });
      } else {
        jsonResponse = convert.jsonDecode(response.body);
        _showDialog('Error: ${jsonResponse['status']}');
        return;
      }
    } catch (e) {
      print('MyError: $e');
      _showDialog('An Error happened');
      return;
    }
  }

}
