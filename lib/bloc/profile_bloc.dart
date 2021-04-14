import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flex/bloc/base_bloc.dart';
import 'package:flex/bloc/home_screen_bloc.dart';
import 'package:flex/helper/app_routes.dart';
import 'package:flex/helper/load_events.dart';
import 'package:flex/service_locator.dart';
import 'package:flex/services/firebase_service.dart';
import 'package:flex/services/navigation_service.dart';
import 'package:flex/services/user_service.dart';
import 'package:rxdart/rxdart.dart';

class ProfileBloc extends BaseBloc {

  final _userService = locator<UserService>();
  final _eventBus = locator<EventBus>();

  BehaviorSubject<UserDetails> _userDetailsSubject = BehaviorSubject<UserDetails>();
  Stream<UserDetails> get userDetailsStream => _userDetailsSubject.stream;
  Sink<UserDetails> get userDetailsSink => _userDetailsSubject.sink;

  void getUserData() async {

    String _uuid = await _userService.getUserId;

    _eventBus.fire(LoadEvent.show());
    DocumentSnapshot doc = await locator<FirebaseService>().getUserData(userId: _uuid).whenComplete(() {
      _eventBus.fire(LoadEvent.hide());
    });

    userDetailsSink.add(UserDetails(doc.data()));

    print(doc.data());
  }

  Future<dynamic> navigateToEditScreen() async {
    return locator<NavigationService>().pushNamed(CHANGE_USER_DETAILS_SCREEN);
  }

  void logout() async {
    await locator<FirebaseService>().signOut().then((value) {
      locator<NavigationService>().pushReplacement(LANDING_SCREEN);
    });
  }

  @override
  dispose() {
    _userDetailsSubject.close();
  }
}