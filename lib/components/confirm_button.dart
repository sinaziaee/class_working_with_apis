import 'package:flutter/material.dart';
import 'package:working_with_apis/screens/login_screen.dart';

import '../constants.dart';

class MyConfirmButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color color;

  MyConfirmButton({this.text, this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: LoginScreen.size.width,
      height: LoginScreen.size.height * 0.06,
      margin: EdgeInsets.symmetric(
        horizontal: LoginScreen.size.width * 0.05,
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            color ?? Colors.red,
          ),
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: Text(
          text,
          style: kBodyTextStyle.copyWith(
            color: Colors.white,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
