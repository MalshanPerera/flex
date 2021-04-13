import 'package:flex/helper/app_routes.dart';
import 'package:flex/service_locator.dart';
import 'package:flex/services/navigation_service.dart';

class LandingScreenBloc {

  void navigateToLogin(){
    locator<NavigationService>().pushNamed(USER_LOGIN_SCREEN);
  }

  void navigateToRegister(){
    locator<NavigationService>().pushNamed(USER_SIGN_UP_SCREEN);
  }

}