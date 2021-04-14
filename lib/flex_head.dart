import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flex/bloc/change_user_details_bloc.dart';
import 'package:flex/bloc/home_screen_bloc.dart';
import 'package:flex/bloc/landing_screen_bloc.dart';
import 'package:flex/bloc/leaderboard_bloc.dart';
import 'package:flex/bloc/loading_bloc.dart';
import 'package:flex/bloc/onboarding_bloc.dart';
import 'package:flex/bloc/authentication_bloc.dart';
import 'package:flex/bloc/profile_bloc.dart';
import 'package:flex/bloc/workout_bloc.dart';
import 'package:flex/helper/app_colors.dart';
import 'package:flex/helper/app_routes.dart';
import 'package:flex/helper/app_strings.dart';
import 'package:flex/screens/onboarding_screen.dart';
import 'package:flex/screens/landing_screen.dart';
import 'package:flex/screens/splash_screen.dart';
import 'package:flex/screens/user_screens/change_user_details_screen.dart';
import 'package:flex/screens/user_screens/content_screen.dart';
import 'package:flex/screens/user_screens/user_login_screen.dart';
import 'package:flex/screens/user_screens/user_sigin_up_screen.dart';
import 'package:flex/screens/user_screens/workout_screens/abs_screen.dart';
import 'package:flex/screens/user_screens/workout_screens/arms_screen.dart';
import 'package:flex/screens/user_screens/workout_screens/full_body_screen.dart';
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

  HomeScreenBloc _homeScreenBloc;
  LeaderboardBloc _leaderboardBloc;
  ProfileBloc _profileBloc;

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
        Provider<AuthenticationBloc>(
          create: (_) => AuthenticationBloc(),
        ),
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
        // initialRoute: SPLASH_SCREEN,
        onGenerateRoute: (routeSettings) {
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
                builder: (c) => Provider(
                  create: (context) => LandingScreenBloc(),
                  child: LandingScreen(),
                ),
              );
            case USER_SIGN_UP_SCREEN:
              return MaterialPageRoute(
                builder: (c) => UserSignUpScreen(),
              );
            case USER_LOGIN_SCREEN:
              return MaterialPageRoute(
                builder: (c) => UserLoginScreen(),
              );
            case CONTENT_SCREEN:
              return MaterialPageRoute(
                builder: (c) => MultiProvider(
                  providers: [
                    Provider<HomeScreenBloc>(
                      create: (context) {
                        _homeScreenBloc = HomeScreenBloc();
                        return _homeScreenBloc;
                      },
                      dispose: (_,bloc) => bloc.dispose(),
                    ),
                    Provider<LeaderboardBloc>(
                      create: (context) {
                        _leaderboardBloc = LeaderboardBloc();
                        return _leaderboardBloc;
                      },
                      dispose: (_,bloc) => bloc.dispose(),
                    ),
                    Provider<ProfileBloc>(
                      create: (context) {
                        _profileBloc = ProfileBloc();
                        return _profileBloc;
                      },
                      dispose: (_,bloc) => bloc.dispose(),
                    ),
                  ],
                  child: ContentScreen(),
                ),
              );
            case ARMS_WORKOUT_SCREEN:
              return MaterialPageRoute(
                builder: (c) => Provider(
                  create: (context) => WorkoutBloc(),
                  child: ArmsWorkoutScreen(),
                  dispose: (_, bloc) => bloc.dispose(),
                ),
              );
            case ABS_WORKOUT_SCREEN:
              return MaterialPageRoute(
                builder: (c) => Provider(
                  create: (context) => WorkoutBloc(),
                  child: AbsWorkoutScreen(),
                  dispose: (_, bloc) => bloc.dispose(),
                ),
              );
            case FULL_BODY_WORKOUT_SCREEN:
              return MaterialPageRoute(
                builder: (c) => Provider(
                  create: (context) => WorkoutBloc(),
                  child: FullBodyWorkoutScreen(),
                  dispose: (_, bloc) => bloc.dispose(),
                ),
              );
            case CHANGE_USER_DETAILS_SCREEN:
              return MaterialPageRoute(
                builder: (c) => Provider(
                  create: (context) => ChangeUserDetailsBloc(),
                  child: ChangeUserDetailsScreen(),
                  dispose: (_, bloc) => bloc.dispose(),
                ),
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