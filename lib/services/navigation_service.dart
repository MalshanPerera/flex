import 'package:flex/helper/app_enums.dart';
import 'package:flex/widgets/custom_snackbar.dart';
import 'package:flutter/widgets.dart';

class NavigationService {

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  void pop({bool isTrue}) {
    return _navigatorKey.currentState.pop(isTrue);
  }

  Future<dynamic> pushNamed(String routeName, {Object args}) {
    return _navigatorKey.currentState.pushNamed(routeName, arguments: args);
  }

  Future<dynamic> pushReplacement(String routeName, {Object args}) {
    return _navigatorKey.currentState.pushReplacementNamed(routeName, arguments: args);
  }

  Future<dynamic> pushReplacementUtil(String routeName, {Object args}) {
    return _navigatorKey.currentState.pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false, arguments: args);
  }

  void showError(ExceptionTypes type, String error) {
    final context = _navigatorKey.currentState.overlay.context;
    final DisplayError handler = DisplayImpl();
    handler.showError(
      context,
      errorType: type.name,
      message: error,
    );
  }

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
}