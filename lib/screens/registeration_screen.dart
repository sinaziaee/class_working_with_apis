import 'package:flutter/material.dart';
import 'package:working_with_apis/components/confirm_button.dart';
import 'package:working_with_apis/components/custom_dialog.dart';
import 'package:working_with_apis/components/custom_textfield.dart';
import 'package:working_with_apis/models/user.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  User user;
  FocusNode node;
  TextEditingController emailController, passwordController,
  rePasswordController, firstNameController, lastNameController;
  String token;
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
        token: token);
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
