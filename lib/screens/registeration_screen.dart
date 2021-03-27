import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:working_with_apis/components/confirm_button.dart';
import 'package:working_with_apis/components/custom_dialog.dart';
import 'package:working_with_apis/components/custom_textfield.dart';
import 'package:working_with_apis/constants.dart';
import 'package:working_with_apis/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:working_with_apis/screens/home_screen.dart';

import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  User user;
  FocusNode node;
  TextEditingController emailController,
      passwordController,
      rePasswordController,
      firstNameController,
      lastNameController;
  String token;

  String url = '$mainUrl/api/register/';

  @override
  void initState() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    rePasswordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    node = FocusScope.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: LoginScreen.size.height * 0.02,
              ),
              Row(
                children: [
                  SizedBox(
                    width: LoginScreen.size.width * 0.05,
                  ),
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: LoginScreen.size.height * 0.03,
              ),
              MyTextField(
                hint: "First Name",
                node: node,
                isLast: false,
                isPassword: false,
                controller: emailController,
                color: Colors.black,
              ),
              MyTextField(
                hint: "Last Name",
                node: node,
                isLast: false,
                isPassword: false,
                controller: emailController,
                color: Colors.black,
              ),
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
                isLast: false,
                isPassword: true,
                controller: emailController,
                color: Colors.black,
              ),
              MyTextField(
                hint: "Re-Password",
                node: node,
                isLast: true,
                isPassword: true,
                controller: passwordController,
                color: Colors.black,
              ),
              SizedBox(
                height: LoginScreen.size.height * 0.04,
              ),
              MyConfirmButton(
                text: 'Continue',
                onPressed: () {
                  onContinuePressed();
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.popAndPushNamed(context, LoginScreen.id);
                },
                child: Text(
                  'I have an account, go to Login',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isValidated() {
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    String password = passwordController.text;
    String rePassword = rePasswordController.text;
    String email = emailController.text;
    if (firstName.length < 3) {
      _showDialog('Bad First Name Format');
      return false;
    } else if (lastName.length < 3) {
      _showDialog('Bad Last Name Format');
      return false;
    } else if (password.length < 3) {
      _showDialog('Bad Password Format');
      return false;
    } else if (rePassword.length < 3) {
      _showDialog('Bad RePassword Format');
      return false;
    }
    if (password == rePassword) {
      _showDialog('Password and Re-Password do not match');
      return false;
    }
    user = User(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        token: '');
    return true;
  }

  onContinuePressed() async {
    if (isValidated()) {
      await uploadInfo(user);
      await saveToPreferences(user);
      Navigator.pushNamed(
        context,
        HomeScreen.id,
        arguments: {
          'user': user,
        },
      );
    } else {
      // pass
    }
  }

  _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
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

  Future<void> uploadInfo(User user) async {
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        body: {
          user.toJson(),
        },
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
      );
      var jsonResponse = convert.jsonDecode(response.body);
      if (response.statusCode < 400) {
        user.token = jsonResponse['token'];
        // _showDialog('Successful');
      } else {
        _showDialog('Error: ${jsonResponse['status']}');
        return;
      }
    } catch (e) {
      print('MyError: $e');
      _showDialog('An Error happened');
      return;
    }
  }

  Future<void> saveToPreferences(User user) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (user.firstName != null) {
      preferences.setString("firstName", user.firstName);
    }
    if (user.lastName != null) {
      preferences.setString("lastName", user.lastName);
    }
    if (user.password != null) {
      preferences.setString("password", user.password);
    }
    if (user.email != null) {
      preferences.setString("email", user.email);
    }
    if (token != null) {
      preferences.setString("token", token);
    }
  }
}
