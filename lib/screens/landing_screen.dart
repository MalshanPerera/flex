import 'package:flex/bloc/landing_screen_bloc.dart';
import 'package:flex/helper/app_assets.dart';
import 'package:flex/helper/app_colors.dart';
import 'package:flex/helper/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              LANDING_PAGE_PICTURE,
              height: Utils.getDesignHeight(240),
              width: Utils.getDesignWidth(210),
            ),
            Padding(
              padding: EdgeInsets.only(top: Utils.getDesignHeight(50.0)),
              child: Text(
                "Welcome \nto Flex!",
                style: Theme.of(context).primaryTextTheme.headline1.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 40.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              "Sign Up and Start Exploring",
              style: Theme.of(context).primaryTextTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
            Container(
              margin: EdgeInsets.only(top: Utils.getDesignHeight(40.0)),
              width: Utils.getDesignWidth(300),
              height: Utils.getDesignHeight(50),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: SHADOW_COLOR,
                    offset: Offset(0, 0,),
                    blurRadius: 21,
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.grey,
                  elevation: 0.0,
                ),
                child: Text(
                  "Login",
                  style: Theme.of(context).primaryTextTheme.button.copyWith(
                    color: PRIMARY_COLOR
                  ),
                ),
                onPressed: () => Provider.of<LandingScreenBloc>(context, listen: false).navigateToLogin(),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: Utils.getDesignHeight(15.0)),
              width: Utils.getDesignWidth(300),
              height: Utils.getDesignHeight(50),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: SHADOW_COLOR,
                    offset: Offset(0, 0,),
                    blurRadius: 21,
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.grey,
                  elevation: 0.0,
                ),
                child: Text(
                  "Register",
                  style: Theme.of(context).primaryTextTheme.button.copyWith(
                      color: PRIMARY_COLOR
                  ),
                ),
                onPressed: () => Provider.of<LandingScreenBloc>(context, listen: false).navigateToRegister(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
