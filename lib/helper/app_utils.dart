import 'package:flutter/material.dart';

class Utils {

  static double height;
  static double width;

  static void setScreenSizes(BuildContext context){
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
  }

  static getDesignWidth(double designMargin){
    return (designMargin / 375) * width ;
  }

  static getDesignHeight(double designMargin){
    return (designMargin / 812) * height;
  }

}