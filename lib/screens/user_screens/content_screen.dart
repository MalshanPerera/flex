import 'package:flex/helper/app_colors.dart';
import 'package:flutter/material.dart';

class ContentScreen extends StatefulWidget {
  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: BACKGROUND_COLOR,
      child: SafeArea(
        child: Scaffold(),
      ),
    );
  }
}
