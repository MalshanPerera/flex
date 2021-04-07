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

  final userService = locator<UserService>();
  final _eventBus = locator<EventBus>();

  BehaviorSubject<int> _genderRadioBtnSubject = BehaviorSubject<int>();
  Stream<int> get genderRadioBtnStream => _genderRadioBtnSubject.stream;
  Sink<int> get genderRadioBtnSink => _genderRadioBtnSubject.sink;

  BehaviorSubject<int> _userTypeRadioBtnSubject = BehaviorSubject<int>();
  Stream<int> get userTypeRadioBtnStream => _userTypeRadioBtnSubject.stream;
  Sink<int> get userTypeRadioBtnSink => _userTypeRadioBtnSubject.sink;

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

      userService.saveUserId(uid);
      print("UUID: $uid");



    }catch(error){
      print(error.toString());
    }
  }

  void signUp({String email, String password, String name, String gender, String userType}) async {

    String uid;
    Map<String, dynamic> userData = {
      'name': name,
      'gender': gender,
      'userType': userType,
    };

    try {

      _eventBus.fire(LoadEvent.show());
      uid = await locator<FirebaseService>().signUp(email, password, name, gender, userType).whenComplete(() {
        locator<FirebaseService>().setData(userId: uid, map: userData).whenComplete(() {
          _eventBus.fire(LoadEvent.hide());

          if(uid != null){
            locator<NavigationService>().pushReplacement(HOME_SCREEN);
          }
        });
      });

      userService.saveUserId(uid);
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