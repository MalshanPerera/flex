import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flex/bloc/loading_bloc.dart';
import 'package:flex/bloc/onboarding_bloc.dart';
import 'package:flex/bloc/authentication_bloc.dart';
import 'package:flex/helper/app_colors.dart';
import 'package:flex/helper/app_routes.dart';
import 'package:flex/helper/app_strings.dart';
import 'package:flex/screens/home_screen.dart';
import 'package:flex/screens/onboarding_screen.dart';
import 'package:flex/screens/landing_screen.dart';
import 'package:flex/screens/splash_screen.dart';
import 'package:flex/screens/user_screens/user_login_screen.dart';
import 'package:flex/screens/user_screens/user_sigin_up_screen.dart';
import 'package:flex/service_locator.dart';
import 'package:flex/services/base_managers/exceptions.dart';
import 'package:flex/services/error_service.dart';
import 'package:flex/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FelxHead extends StatefulWidget {
  @override
  _FelxHeadState createState() => _FelxHeadState();
}

class _FelxHeadState extends State<FelxHead> {

  final ErrorService errorHandler = locator<ErrorService>();

  StreamSubscription _errorSubscription;
  Stream<SkeletonException> _prevErrorStream;

  @override
  void initState() {
    super.initState();

    Firebase.initializeApp();

    if(_prevErrorStream != errorHandler.getErrorText){
      _prevErrorStream = errorHandler.getErrorText;
      _errorSubscription?.cancel();
      listenToErrors();
    }

  }

  @override
  void dispose() {
    _errorSubscription?.cancel();
    errorHandler.dispose();
    super.dispose();
  }

  void listenToErrors(){
    _errorSubscription = _prevErrorStream.listen((error){
      locator<NavigationService>().showError(error.type, error.message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LoadingBloc>(
          create: (_) => LoadingBloc(),
          dispose: (_, bloc) => bloc.dispose(),
        ),
      ],
      child: MaterialApp(
        title: APP_NAME,
        debugShowCheckedModeBanner: false,
        navigatorKey: locator<NavigationService>().navigatorKey,
        theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            textSelectionTheme: TextSelectionThemeData(
              selectionHandleColor: PRIMARY_COLOR,
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: 'Poppins',
            primaryTextTheme: TextTheme(
              headline1: TextStyle(
                  color: PRIMARY_COLOR,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500
              ),
              bodyText1: TextStyle(
                color: PRIMARY_COLOR,
                fontSize: 15.0,
              ),
              button: TextStyle(
                color: PRIMARY_COLOR,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
              bodyText2: TextStyle(
                color: PRIMARY_COLOR,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
              subtitle1: TextStyle(
                color: PRIMARY_COLOR,
                fontSize: 16.0,
                fontWeight: FontWeight.w100,
              ),
              subtitle2: TextStyle(
                color: PRIMARY_COLOR,
                fontSize: 16.0,
                fontWeight: FontWeight.w300,
              ),
            )
        ),
        initialRoute: SPLASH_SCREEN,
        onGenerateRoute: (routeSettings){
          switch (routeSettings.name) {
            case ON_BOARDING_SCREEN:
              return MaterialPageRoute(
                builder: (c) => Provider(
                  create: (context) => OnBoardingBloc(),
                  child: OnBoardingScreen(),
                  dispose: (_,bloc) => bloc.dispose(),
                ),
              );
            case LANDING_SCREEN:
              return MaterialPageRoute(
                builder: (c) => LandingScreen(),
              );
            case USER_SIGN_UP_SCREEN:
              return MaterialPageRoute(
                builder: (c) => Provider(
                  create: (context) => AuthenticationBloc(),
                  child: UserSignUpScreen(),
                  dispose: (_,bloc) => bloc.dispose(),
                ),
              );
            case USER_LOGIN_SCREEN:
              return MaterialPageRoute(
                builder: (c) => Provider(
                  create: (context) => AuthenticationBloc(),
                  child: UserLoginScreen(),
                  dispose: (_,bloc) => bloc.dispose(),
                ),
              );
            case HOME_SCREEN:
              return MaterialPageRoute(
                  builder: (c) => HomeScreen(),
              );
            default:
              return MaterialPageRoute(
                builder: (c) => SplashScreen(),
              );
          }
        },
      ),
    );
  }
}