import 'package:flutter/material.dart';
import 'package:working_with_apis/screens/login_screen.dart';

import '../constants.dart';

class MyTestField extends StatelessWidget {
  final Color color;
  final FocusNode node;
  final bool isLast;
  final String hint;
  final bool isPassword;
  final TextEditingController controller;

  MyTestField({this.hint, this.isPassword, this.color, this.node, this.controller, this.isLast});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: LoginScreen.size.height * 0.06,
      margin: EdgeInsets.symmetric(
          horizontal: LoginScreen.size.width * 0.05,
          vertical: LoginScreen.size.height * 0.005
      ),
      child: TextFormField(
        controller: controller,
        onEditingComplete: () => (isLast == null || isLast == false)
            ? node.nextFocus()
            : node.unfocus(),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
            bottom: LoginScreen.size.height * 0.03,
            left: LoginScreen.size.width * 0.03,
            right: LoginScreen.size.width * 0.03,
          ),
          hintText: hint,
          focusedBorder: kOutLineInputBorder.copyWith(
            borderSide: BorderSide(
              color: color ?? Colors.black,
              width: 1.5,
              style: BorderStyle.solid,
            ),
          ),
          border: kOutLineInputBorder.copyWith(
            borderSide: BorderSide(
              color: color ?? Colors.grey,
              width: 0.5,
              style: BorderStyle.solid,
            ),
          ),
        ),
      ),
    );
  }
}
