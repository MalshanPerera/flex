import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flex/bloc/base_bloc.dart';
import 'package:flex/helper/app_routes.dart';
import 'package:flex/helper/load_events.dart';
import 'package:flex/service_locator.dart';
import 'package:flex/services/firebase_service.dart';
import 'package:flex/services/navigation_service.dart';
import 'package:flex/services/user_service.dart';
import 'package:rxdart/rxdart.dart';

class HomeScreenBloc extends BaseBloc {

  final _userService = locator<UserService>();
  final _eventBus = locator<EventBus>();

  String _uuid;

  BehaviorSubject<UserDetails> _userDetailsSubject = BehaviorSubject<UserDetails>();
  Stream<UserDetails> get userDetailsStream => _userDetailsSubject.stream;
  Sink<UserDetails> get userDetailsSink => _userDetailsSubject.sink;

  void navigateToWorkoutScreen(int index){
    if(index == 0){
      locator<NavigationService>().pushNamed(ARMS_WORKOUT_SCREEN);
    }

    if(index == 1){
      locator<NavigationService>().pushNamed(ABS_WORKOUT_SCREEN);
    }

    if(index == 2){
      locator<NavigationService>().pushNamed(FULL_BODY_WORKOUT_SCREEN);
    }
  }

  void getUserData() async {

    _uuid = await _userService.getUserId;

    _eventBus.fire(LoadEvent.show());
    DocumentSnapshot doc = await locator<FirebaseService>().getUserData(userId: _uuid).whenComplete(() {
      _eventBus.fire(LoadEvent.hide());
    });

    userDetailsSink.add(UserDetails(doc.data()));

    print(doc.data());

  }

  @override
  dispose() {
    _userDetailsSubject.close();
  }

}

class UserDetails {

  String name;
  String gender;
  String userType;
  int level;
  int points;
  double absProgress;
  double armsProgress;
  double fullBodyProgress;
  double weight;
  double height;
  int expPoints;
  List<String> achievementsList = [];
  List<String> badgesList = [];

  UserDetails(Map<String, dynamic> parseJSON){
    name = parseJSON['name'] ?? "";
    gender = parseJSON['gender'] ?? "";
    userType = parseJSON['userType'] ?? "";
    level = parseJSON['level'] ?? 1;
    points = parseJSON['points'] ?? 0;
    absProgress = parseJSON['abs_progress'].toDouble() ?? 0.0;
    armsProgress = parseJSON['arms_progress'].toDouble() ?? 0.0;
    fullBodyProgress = parseJSON['full_body_progress'].toDouble() ?? 0.0;
    weight = parseJSON['weight'].toDouble() ?? 0.0;
    height = parseJSON['height'].toDouble() ?? 0.0;
    expPoints = parseJSON['expPoints'] ?? 0;

    if (parseJSON['achievements'] != null) {
      parseJSON['achievements'].forEach((achievement){
        achievementsList.add(achievement);
      });
    }

    if (parseJSON['badges'] != null) {
      parseJSON['badges'].forEach((badge){
        badgesList.add(badge);
      });
    }
  }
}