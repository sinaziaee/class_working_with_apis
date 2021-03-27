import 'package:flutter/material.dart';

import '../constants.dart';
import 'confirm_button.dart';

class CustomDialog extends StatelessWidget {
  final String message;
  final Color color;
  final String text;
  final Function onPressed;

  CustomDialog({this.message, this.color, this.text, this.onPressed});

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
        onPressed: onPressed,
        text: text,
      ),
    );

  }

}
