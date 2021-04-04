import 'package:flex/screens/onboarding_screen.dart';
import 'package:flex/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class FelxHead extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flex',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      onGenerateRoute: (routeSettings){
        switch (routeSettings.name) {
          case '/onBoarding_screen':
            return MaterialPageRoute(
              builder: (c) => OnBoardingScreen(),
            );
          default:
            return MaterialPageRoute(
              builder: (c) => SplashScreen(),
            );
        }
      },
    );
  }
}