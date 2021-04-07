import 'package:flex/helper/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

abstract class DisplayError {
  void showError(BuildContext context, {String errorType="", String message=""});
}

class DisplayImpl extends DisplayError {

  @override
  void showError(BuildContext context, {String errorType="", String message=""}) {

    final Flushbar _flushBar = Flushbar(
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      backgroundColor: PRIMARY_COLOR,
      isDismissible: true,
      duration: Duration(seconds: 3),
      icon: Icon(
        Icons.error_outline,
        color: Colors.white,
      ),
      mainButton: FlatButton(
        onPressed: () {},
        child: Text(
          "OK",
          style: TextStyle(color: Colors.white),
        ),
      ),
      titleText: Text(
        errorType,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white, fontFamily: "ShadowsIntoLightTwo"),
      ),
      messageText: Text(
        message,
        style: TextStyle(fontSize: 18.0, color: Colors.white, fontFamily: "ShadowsIntoLightTwo"),
      ),
    );

    _flushBar.show(context);
  }

}