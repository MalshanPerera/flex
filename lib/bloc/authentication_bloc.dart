import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flex/bloc/base_bloc.dart';
import 'package:flex/helper/app_data.dart';
import 'package:flex/helper/app_enums.dart';
import 'package:flex/helper/app_methods.dart';
import 'package:flex/helper/app_routes.dart';
import 'package:flex/helper/load_events.dart';
import 'package:flex/service_locator.dart';
import 'package:flex/services/firebase_service.dart';
import 'package:flex/services/navigation_service.dart';
import 'package:flex/services/user_service.dart';
import 'package:rxdart/rxdart.dart';

class AuthenticationBloc extends BaseBloc {

  final _appData = AppData.getInstance; //singleton network instance

  final _userService = locator<UserService>();
  final _eventBus = locator<EventBus>();

  String _uuid;

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
    locator<NavigationService>().pushReplacementUtil(loggedIn ? CONTENT_SCREEN : LANDING_SCREEN);
  }

  Future<bool> login({String email, String password}) async {

    String uid;

    try{

      _eventBus.fire(LoadEvent.show());
      uid = await locator<FirebaseService>().signIn(email, password).whenComplete(() {
        _eventBus.fire(LoadEvent.hide());
      });

      // Uid gets null inside the whenComplete
      if(uid != null){
        locator<NavigationService>().pushReplacement(CONTENT_SCREEN, args: false);
      }

      _userService.saveUserId(uid);
      print("UUID: $uid");

      return true;

    }catch(error){
      print(error.toString());
      return false;
    }
  }

  Future<bool> signUp({String email, String password, String name, String gender, double weight, double height, String userType}) async {

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
      'gamification_element_rating': [],
      'weight': weight,
      'height': height,
      'expPoints': 0,
      'step': 0,
      'game_elements': AppMethods.getElements(userType: userType),
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
        locator<NavigationService>().pushReplacement(ON_BOARDING_SCREEN);
      }

      _userService.saveUserId(uid);
      print("UUID: $uid");

      return true;

    }catch(error){
      print(error.toString());
      return false;
    }
  }

  void getUserData() async {

    _uuid = await _userService.getUserId;
    print(_uuid);

    DocumentSnapshot doc = await locator<FirebaseService>().getUserData(userId: _uuid);

    if(_uuid != null){
      print(AppMethods.getElements(userType: doc.data()['userType']));

      _appData.achievementsBadges = AppMethods.getElements(userType: doc.data()['userType'])['achievements_badges'];
      _appData.leaderboard = AppMethods.getElements(userType: doc.data()['userType'])['leaderboard'];
      _appData.level = AppMethods.getElements(userType: doc.data()['userType'])['level'];
      _appData.story = AppMethods.getElements(userType: doc.data()['userType'])['story'];

      if(doc.data()['userType'] == "Achiever"){
        _appData.userTypes = UserTypes.ACHIEVER;
      }
      if(doc.data()['userType'] == "Socializer"){
        _appData.userTypes = UserTypes.SOCIALIZER;
      }
      if(doc.data()['userType'] == "Explorer"){
        _appData.userTypes = UserTypes.EXPLORER;
      }
      if(doc.data()['userType'] == "Killer"){
        _appData.userTypes = UserTypes.KILLER;
      }
    }
  }

  @override
  dispose() {
    _genderRadioBtnSubject.close();
    _userTypeRadioBtnSubject.close();
  }

}