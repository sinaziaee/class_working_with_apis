import 'package:flutter/material.dart';
import 'package:working_with_apis/components/confirm_button.dart';
import 'package:working_with_apis/components/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  static Size size;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode node;
  TextEditingController emailController, passwordController;
  @override
  Widget build(BuildContext context) {
    node = FocusScope.of(context);
    LoginScreen.size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyTestField(
                hint: "Email",
                node: node,
                isLast: false,
                isPassword: false,
                controller: emailController,
                color: Colors.black,
              ),
              MyTestField(
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

  onContinuePressed(){

  }

}
