import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flex/bloc/base_bloc.dart';
import 'package:flex/bloc/home_screen_bloc.dart';
import 'package:flex/helper/app_data.dart';
import 'package:flex/helper/app_enums.dart';
import 'package:flex/helper/app_routes.dart';
import 'package:flex/helper/load_events.dart';
import 'package:flex/service_locator.dart';
import 'package:flex/services/firebase_service.dart';
import 'package:flex/services/navigation_service.dart';
import 'package:flex/services/user_service.dart';
import 'package:rxdart/rxdart.dart';

class ProfileBloc extends BaseBloc {

  final _appData = AppData.getInstance; //singleton network instance

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

    _appData.achievementsBadges = doc.data()['game_elements']['achievements_badges'];
    _appData.leaderboard = doc.data()['game_elements']['leaderboard'];
    _appData.level = doc.data()['game_elements']['level'];
    _appData.story = doc.data()['game_elements']['story'];
    _appData.points = doc.data()['game_elements']['points'];

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

  Future<dynamic> navigateToEditScreen() async {
    return locator<NavigationService>().pushNamed(CHANGE_USER_DETAILS_SCREEN);
  }

  void logout() async {
    _userService.clear().whenComplete(() async {
      await locator<FirebaseService>().signOut().then((value) {
      locator<NavigationService>().pushReplacement(LANDING_SCREEN);
      });
    });
  }

  @override
  dispose() {
    _userDetailsSubject.close();
  }
}