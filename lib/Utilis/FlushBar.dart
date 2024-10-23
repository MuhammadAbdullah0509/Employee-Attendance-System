


import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';



class Utilis{
  static flushBarMessage(String msg, BuildContext context) {
     showFlushbar(
      context: context,
      flushbar: Flushbar(
        padding: const EdgeInsets.all(10),
        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
        titleSize: 15,
        titleColor: Colors.white,
        backgroundColor: Colors.teal,
        flushbarPosition: FlushbarPosition.TOP,
        duration: const Duration(seconds: 3),
        message: msg,
      )..show(context),
    );
  }
}