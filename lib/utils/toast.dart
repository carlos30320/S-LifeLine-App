import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastStatus { success, warning, error, info, none }

void showToast(
  String message, {
  ToastStatus status = ToastStatus.none,
}) {
  Color? backgroundColor;
  switch (status) {
    case ToastStatus.success:
      backgroundColor = Colors.green;
      break;
    case ToastStatus.warning:
      backgroundColor = Colors.orange;
      break;
    case ToastStatus.error:
      backgroundColor = Colors.red;
      break;
    case ToastStatus.info:
      backgroundColor = Colors.blue;
      break;
    default:
      backgroundColor = Colors.grey[900]; // default color
      break;
  }

  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: backgroundColor,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
