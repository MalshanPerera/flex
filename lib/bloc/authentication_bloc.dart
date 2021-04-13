import 'package:event_bus/event_bus.dart';
import 'package:flex/bloc/base_bloc.dart';
import 'package:flex/helper/app_routes.dart';
import 'package:flex/helper/load_events.dart';
import 'package:flex/service_locator.dart';
import 'package:flex/services/firebase_service.dart';
import 'package:flex/services/navigation_service.dart';
import 'package:flex/services/user_service.dart';
import 'package:rxdart/rxdart.dart';

class AuthenticationBloc extends BaseBloc {

  final _userService = locator<UserService>();
  final _eventBus = locator<EventBus>();

  BehaviorSubject<int> _genderRadioBtnSubject = BehaviorSubject<int>();
  Stream<int> get genderRadioBtnStream => _genderRadioBtnSubject.stream;
  Sink<int> get genderRadioBtnSink => _genderRadioBtnSubject.sink;

  BehaviorSubject<int> _userTypeRadioBtnSubject = BehaviorSubject<int>();
  Stream<int> get userTypeRadioBtnStream => _userTypeRadioBtnSubject.stream;
  Sink<int> get userTypeRadioBtnSink => _userTypeRadioBtnSubject.sink;

  Future<bool> isUserLoggedIn() async {
    return await locator<UserService>().isLoggedIn;
  }

  void checkUserStatusAndNavigate() async {
    bool loggedIn = await isUserLoggedIn();
    locator<NavigationService>().pushReplacement(loggedIn ? CONTENT_SCREEN : LANDING_SCREEN);
  }

  void login({String email, String password}) async {

    String uid;

    try{

      _eventBus.fire(LoadEvent.show());
      uid = await locator<FirebaseService>().signIn(email, password).whenComplete(() {
        _eventBus.fire(LoadEvent.hide());
      });

      // Uid gets null inside the whenComplete
      if(uid != null){
        locator<NavigationService>().pushReplacement(HOME_SCREEN);
      }

      _userService.saveUserId(uid);
      print("UUID: $uid");

    }catch(error){
      print(error.toString());
    }
  }

  void signUp({String email, String password, String name, String gender, double weight, double height, String userType}) async {

    String uid;
    Map<String, dynamic> userData = {
      'name': name,
      'gender': gender,
      'userType': userType,
      'level': 1,
      'points': 0,
      'full_body_progress': 0.0,
      'arms_progress': 0.0,
      'abs_progress': 0.0,
      'achievement': [],
      'badges': [],
      'motivation_rating': [],
      'weight': weight,
      'height': height,
      'expPoints': 0,
    };

    try {

      _eventBus.fire(LoadEvent.show());
      uid = await locator<FirebaseService>().signUp(email, password, name, gender, userType);
      await locator<FirebaseService>().setData(userId: uid, map: userData);
      await locator<FirebaseService>().setLeaderboardData(uid: uid, map: {
        'uid': uid,
        'name': name,
        'points': 0,
      });
      _eventBus.fire(LoadEvent.hide());
      if(uid != null){
        locator<NavigationService>().pushReplacement(HOME_SCREEN);
      }

      _userService.saveUserId(uid);
      print("UUID: $uid");

    }catch(error){
      print(error.toString());
    }
  }

  @override
  dispose() {
    _genderRadioBtnSubject.close();
    _userTypeRadioBtnSubject.close();
  }

}