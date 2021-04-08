import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flex/bloc/base_bloc.dart';
import 'package:flex/helper/load_events.dart';
import 'package:flex/service_locator.dart';
import 'package:flex/services/firebase_service.dart';
import 'package:flex/services/user_service.dart';
import 'package:rxdart/rxdart.dart';

class HomeScreenBloc extends BaseBloc {

  final _userService = locator<UserService>();
  final _eventBus = locator<EventBus>();

  String _uuid;

  BehaviorSubject<UserDetails> _userNameSubject = BehaviorSubject<UserDetails>();
  Stream<UserDetails> get userNameStream => _userNameSubject.stream;
  Sink<UserDetails> get userNameSink => _userNameSubject.sink;

  void getUserData() async {

    _uuid = await _userService.getUserId;

    _eventBus.fire(LoadEvent.show());
    DocumentSnapshot doc = await locator<FirebaseService>().getUserData(userId: _uuid).whenComplete(() {
      _eventBus.fire(LoadEvent.hide());
    });

    userNameSink.add(UserDetails(doc.data()));

    print(doc.data());

  }

  @override
  dispose() {
    _userNameSubject.close();
  }

}

class UserDetails {

  String name;
  String gender;
  String userType;

  UserDetails(Map<String, dynamic> parseJSON){
    name = parseJSON['name'];
    gender = parseJSON['gender'];
    userType = parseJSON['userType'];
  }
}