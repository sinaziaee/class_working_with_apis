import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:working_with_apis/components/confirm_button.dart';
import 'package:working_with_apis/components/custom_dialog.dart';
import 'package:working_with_apis/components/custom_textfield.dart';
import 'package:working_with_apis/models/user.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  static Size size;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode node;
  TextEditingController emailController, passwordController;
  User user;
  String token;

  Future<bool> getToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString("token") != null && prefs.getString("token").length != 0){
      Navigator.popAndPushNamed(context, HomeScreen.id);
    }
    else{
      // pass
    }
  }

  @override
  Widget build(BuildContext context) {
    node = FocusScope.of(context);
    LoginScreen.size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: getToken(),
      builder: (context, snapshot) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MyTextField(
                    hint: "Email",
                    node: node,
                    isLast: false,
                    isPassword: false,
                    controller: emailController,
                    color: Colors.black,
                  ),
                  MyTextField(
                    hint: "Password",
                    node: node,
                    isLast: true,
                    isPassword: true,
                    controller: passwordController,
                    color: Colors.black,
                  ),
                  MyConfirmButton(
                    text: 'Continue',
                    onPressed: () {
                      onContinuePressed();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool isValidated() {
    String password = passwordController.text;
    String email = emailController.text;
    if (email.length < 3) {
      _showDialog('Bad Email Format');
      return false;
    } else if (password.length < 3) {
      _showDialog('Bad Password Format');
      return false;
    }
    return true;
  }

  onContinuePressed() {}

  _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          color: Colors.black,
          text: 'OK !!!',
          onPressed: () {
            Navigator.pop(context);
          },
          message: message,
        );
      },
    );
  }
}
