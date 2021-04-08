import 'dart:async';

import 'package:flex/bloc/authentication_bloc.dart';
import 'package:flex/helper/app_colors.dart';
import 'package:flex/helper/app_routes.dart';
import 'package:flex/helper/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    _loadScreen();
  }

  @override
  Widget build(BuildContext context) {

    Utils.setScreenSizes(context);

    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      body: Center(
        child: SizedBox(
          height: Utils.getDesignHeight(220),
          width: Utils.getDesignWidth(220),
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
    );
  }

  _loadScreen() async {
    var _duration = Duration(seconds: 3);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Provider.of<AuthenticationBloc>(context, listen: false).checkUserStatusAndNavigate();
    // Navigator.pushReplacementNamed(context, LANDING_SCREEN);
  }
}
