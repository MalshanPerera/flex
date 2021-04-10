import 'package:flex/helper/app_colors.dart';
import 'package:flutter/material.dart';

class ArmsWorkoutScreen extends StatefulWidget {
  @override
  _WorkoutScreenshotsState createState() => _WorkoutScreenshotsState();
}

class _WorkoutScreenshotsState extends State<ArmsWorkoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: BACKGROUND_COLOR,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: BACKGROUND_COLOR,
          body: Center(
            child: Text(
              "Coming Soon...",
              style: Theme.of(context).primaryTextTheme.headline1,
            ),
          ),
        ),
      ),
    );
  }
}