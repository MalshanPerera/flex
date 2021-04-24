import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flex/bloc/base_bloc.dart';
import 'package:flex/bloc/home_screen_bloc.dart';
import 'package:flex/helper/app_data.dart';
import 'package:flex/helper/app_enums.dart';
import 'package:flex/helper/app_methods.dart';
import 'package:flex/helper/load_events.dart';
import 'package:flex/service_locator.dart';
import 'package:flex/services/firebase_service.dart';
import 'package:flex/services/navigation_service.dart';
import 'package:flex/services/user_service.dart';
import 'package:rxdart/rxdart.dart';

class ChangeUserDetailsBloc extends BaseBloc {

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

  BehaviorSubject<UserDetails> _userDetailsSubject = BehaviorSubject<UserDetails>();
  Stream<UserDetails> get userDetailsStream => _userDetailsSubject.stream;
  Sink<UserDetails> get userDetailsSink => _userDetailsSubject.sink;

  PublishSubject<int> _tabIndexSubject = PublishSubject<int>();
  Stream<int> get tabIndexStream => _tabIndexSubject.stream;
  Sink<int> get tabIndexSink => _tabIndexSubject.sink;

  BehaviorSubject<bool> _levelSubject = BehaviorSubject<bool>();
  Stream<bool> get levelStream => _levelSubject.stream;
  Sink<bool> get levelSink => _levelSubject.sink;

  BehaviorSubject<bool> _achievementAndBadgesSubject = BehaviorSubject<bool>();
  Stream<bool> get achievementAndBadgesStream => _achievementAndBadgesSubject.stream;
  Sink<bool> get achievementAndBadgesSink => _achievementAndBadgesSubject.sink;

  BehaviorSubject<bool> _leaderboardSubject = BehaviorSubject<bool>();
  Stream<bool> get leaderboardStream => _leaderboardSubject.stream;
  Sink<bool> get leaderboardSink => _leaderboardSubject.sink;

  BehaviorSubject<bool> _storySubject = BehaviorSubject<bool>();
  Stream<bool> get storyStream => _storySubject.stream;
  Sink<bool> get storySink => _storySubject.sink;

  void getUserData() async {

    _uuid = await _userService.getUserId;

    _eventBus.fire(LoadEvent.show());
    DocumentSnapshot doc = await locator<FirebaseService>().getUserData(userId: _uuid).whenComplete(() {
      _eventBus.fire(LoadEvent.hide());
    });

    userDetailsSink.add(UserDetails(doc.data()));

    achievementAndBadgesSink.add(doc.data()['game_elements']['achievements_badges']);
    leaderboardSink.add(doc.data()['game_elements']['leaderboard']);
    storySink.add(doc.data()['game_elements']['story']);
    levelSink.add(doc.data()['game_elements']['level']);

    _appData.achievementsBadges = doc.data()['game_elements']['achievements_badges'];
    _appData.leaderboard = doc.data()['game_elements']['leaderboard'];
    _appData.level = doc.data()['game_elements']['level'];
    _appData.story = doc.data()['game_elements']['story'];

    tabIndexSink.add(0);

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

  void changeUserDetails({String name, double weight, double height, String userType}) async {

    Map<String, dynamic> userData = {
      'name': name,
      'userType': userType,
      'weight': weight,
      'height': height,
      'game_elements': _appData.userTypes != _userType(userType: userType) ? _elements(userType) : {
        'achievements_badges': _achievementAndBadgesSubject.value,
        'leaderboard': _leaderboardSubject.value,
        'story': _storySubject.value,
        'level': _levelSubject.value,
      },
    };

    try {

      _eventBus.fire(LoadEvent.show());
      await locator<FirebaseService>().updateUserData(userId: _uuid, map: userData).whenComplete(() => getUserData());
      _eventBus.fire(LoadEvent.hide());

      tabIndexSink.add(_appData.leaderboard ? 2 : 1);

      // locator<NavigationService>().showError(ExceptionTypes.SUCCESS, "User Details Updated Successfully!!");
      locator<NavigationService>().pop(isTrue: true);

    }catch(error){
      print(error.toString());
    }
  }

  Map<String, bool> _elements(String userType){

    print(userType);

    if(userType == "Killer"){
      return {
        'achievements_badges': false,
        'leaderboard': true,
        'story': false,
        'level': true,
      };
    }
    if(userType == "Explorer"){
      return {
        'achievements_badges': true,
        'leaderboard': false,
        'story': true,
        'level': true,
      };
    }
    if(userType == "Achiever"){
      return {
        'achievements_badges': true,
        'leaderboard': true,
        'story': false,
        'level': true,
      };
    }
    if(userType == "Socializer"){
      return {
        'achievements_badges': true,
        'leaderboard': false,
        'story': true,
        'level': false,
      };
    }

    return {
      'achievements_badges': false,
      'leaderboard': false,
      'story': false,
      'level': false,
    };
  }

  UserTypes _userType({String userType}){

    if(userType == "Achiever"){
      return UserTypes.ACHIEVER;
    }

    if(userType == "Socializer"){
      return UserTypes.SOCIALIZER;
    }

    if(userType == "Explorer"){
      return UserTypes.EXPLORER;
    }

    if(userType == "Killer"){
      return UserTypes.KILLER;
    }

    return UserTypes.NON;
  }

  @override
  dispose() {
    _genderRadioBtnSubject.close();
    _userTypeRadioBtnSubject.close();
    _userDetailsSubject.close();
    _levelSubject.close();
    _achievementAndBadgesSubject.close();
    _leaderboardSubject.close();
    _storySubject.close();
    _tabIndexSubject.close();
  }

}