import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:working_with_apis/components/confirm_button.dart';
import 'package:working_with_apis/components/custom_dialog.dart';
import 'package:working_with_apis/components/custom_textfield.dart';
import 'package:working_with_apis/constants.dart';
import 'package:working_with_apis/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:working_with_apis/screens/registeration_screen.dart';
import 'dart:convert' as convert;
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode node;
  TextEditingController emailController, passwordController;
  User user;
  Size size;
  String url = '$mainUrl/api/account/login/';

  @override
  void initState() {
    getToken();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('token')) {
      String firstName = prefs.getString('firstName');
      String lastName = prefs.getString('lastName');
      String token = prefs.getString('token');
      String email = prefs.getString('email');
      String password = prefs.getString('password');
      user = User(
        firstName: firstName,
        lastName: lastName,
        token: token,
        email: email,
        password: password,
      );
      Navigator.popAndPushNamed(
        context,
        HomeScreen.id,
        arguments: {
          'user': user,
        },
      );
    } else {
      //pass
    }
  }

  @override
  Widget build(BuildContext context) {
    node = FocusScope.of(context);
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.02,
              ),
              Row(
                children: [
                  SizedBox(
                    width: size.width * 0.05,
                  ),
                  Text(
                    'Login',
                    style: kHeaderTextStyle.copyWith(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              MyTextField(
                hint: "Email",
                node: node,
                isLast: false,
                isPassword: false,
                controller: emailController,
                color: Colors.black,
                size: size,
              ),
              SizedBox(
                height: size.height * 0.005,
              ),
              MyTextField(
                size: size,
                hint: "Password",
                node: node,
                isLast: true,
                isPassword: true,
                controller: passwordController,
                color: Colors.black,
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
              TextButton(
                onPressed: () {
                  Navigator.popAndPushNamed(context, RegistrationScreen.id);
                },
                child: Text(
                  'I don\'t have an account, go to sign up',
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
    String password = passwordController.text;
    String email = emailController.text;
    if (email.length < 3) {
      _showDialog('Bad Email Format');
      return false;
    } else if (password.length < 6) {
      _showDialog('Bad Password Format');
      return false;
    }
    user = User(email: email, password: password);
    return true;
  }

  onContinuePressed() async {
    if (isValidated() == true) {
      uploadInfo();
    } else {
      // pass
    }
  }

  _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          size: size,
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

  Future<void> uploadInfo() async {
    // get, post, put, delete
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        body: convert.jsonEncode(
          {
            'username': user.email,
            'password': user.password,
          },
        ),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
      );
      var jsonResponse;
      print('***************************************************');
      print(response.statusCode);
      print(response.body);
      print('***************************************************');
      if (response.statusCode < 300) {
        // encode: کدگذاری کردن
        // decode: کدگشایی
        jsonResponse = convert.jsonDecode(response.body);
        user = User.fromMap(jsonResponse);
        await saveToPreferences(user);
        Navigator.popAndPushNamed(
          context,
          HomeScreen.id,
          arguments: {
            'user': user,
          },
        );
      } else {
        jsonResponse = convert.jsonDecode(response.body);
        print(jsonResponse);
        if (jsonResponse['non_field_errors'] != null) {
          _showDialog('No user found with this email and password');
        } else {
          _showDialog('Error: ${jsonResponse['status']}');
        }
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
    if (user.token != null) {
      preferences.setString("token", user.token);
    }
  }
}
