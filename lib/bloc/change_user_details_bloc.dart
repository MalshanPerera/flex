import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flex/bloc/base_bloc.dart';
import 'package:flex/bloc/home_screen_bloc.dart';
import 'package:flex/helper/load_events.dart';
import 'package:flex/service_locator.dart';
import 'package:flex/services/firebase_service.dart';
import 'package:flex/services/navigation_service.dart';
import 'package:flex/services/user_service.dart';
import 'package:rxdart/rxdart.dart';

class ChangeUserDetailsBloc extends BaseBloc {

  final _userService = locator<UserService>();
  final _eventBus = locator<EventBus>();

  String _uuid;

  BehaviorSubject<int> _genderRadioBtnSubject = BehaviorSubject<int>();
  Stream<int> get genderRadioBtnStream => _genderRadioBtnSubject.stream;
  Sink<int> get genderRadioBtnSink => _genderRadioBtnSubject.sink;

  BehaviorSubject<int> _userTypeRadioBtnSubject = BehaviorSubject<int>();
  Stream<int> get userTypeRadioBtnStream => _userTypeRadioBtnSubject.stream;
  Sink<int> get userTypeRadioBtnSink => _userTypeRadioBtnSubject.sink;

  BehaviorSubject<UserDetails> _userDetailsSubject = BehaviorSubject<UserDetails>();
  Stream<UserDetails> get userDetailsStream => _userDetailsSubject.stream;
  Sink<UserDetails> get userDetailsSink => _userDetailsSubject.sink;

  void getUserData() async {

    _uuid = await _userService.getUserId;

    _eventBus.fire(LoadEvent.show());
    DocumentSnapshot doc = await locator<FirebaseService>().getUserData(userId: _uuid).whenComplete(() {
      _eventBus.fire(LoadEvent.hide());
    });

    userDetailsSink.add(UserDetails(doc.data()));

    print(doc.data());

  }

  void changeUserDetails({String name, double weight, double height, String userType}) async {

    Map<String, dynamic> userData = {
      'name': name,
      'userType': userType,
      'weight': weight,
      'height': height,
    };

    try {

      _eventBus.fire(LoadEvent.show());
      await locator<FirebaseService>().updateUserData(userId: _uuid, map: userData);
      _eventBus.fire(LoadEvent.hide());

      locator<NavigationService>().pop(isTrue: true);

    }catch(error){
      print(error.toString());
    }
  }

  @override
  dispose() {
    _genderRadioBtnSubject.close();
    _userTypeRadioBtnSubject.close();
    _userDetailsSubject.close();
  }

}