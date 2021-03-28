import 'package:flutter/material.dart';

import '../constants.dart';
import 'confirm_button.dart';

class CustomDialog extends StatelessWidget {
  final String message;
  final Color color;
  final String text;
  final Size size;
  final Function onPressed;

  CustomDialog(
      {this.message,
      this.color,
      this.text,
      this.onPressed,
      @required this.size});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        message,
        textAlign: TextAlign.center,
        style: kHeaderTextStyle.copyWith(
          color: color,
        ),
      ),
      content: MyConfirmButton(
        size: size,
        onPressed: onPressed,
        text: text,
      ),
    );
  }
}
