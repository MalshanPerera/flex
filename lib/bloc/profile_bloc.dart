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
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class ProfileBloc extends BaseBloc {

  final _appData = AppData.getInstance; //singleton network instance

  final _userService = locator<UserService>();
  final _eventBus = locator<EventBus>();

  String _uuid;

  BehaviorSubject<UserDetails> _userDetailsSubject = BehaviorSubject<UserDetails>();
  Stream<UserDetails> get userDetailsStream => _userDetailsSubject.stream;
  Sink<UserDetails> get userDetailsSink => _userDetailsSubject.sink;

  BehaviorSubject<bool> _isDateTrueSubject = BehaviorSubject<bool>.seeded(true);
  Stream<bool> get getIsDateTrueStream => _isDateTrueSubject.stream;
  Sink<bool> get setIsDateTrueSink => _isDateTrueSubject.sink;

  BehaviorSubject<double> _gamificationRateSubject = BehaviorSubject<double>();
  Sink<double> get gamificationRateSink => _gamificationRateSubject.sink;

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

  void setTimer() async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String date = formatter.format(now);

    _userService.saveRateDate(date);
    getTimer();
  }

  void getTimer() async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String dateNow = formatter.format(now);

    String setDate = await _userService.getRateDate;

    if(dateNow.contains(setDate ?? "") && setDate != null){
      setIsDateTrueSink.add(true);

    }else{
      setIsDateTrueSink.add(false);
    }
  }

  void setUserData() async {

    _uuid = await _userService.getUserId;

    List<double> rates = [];

    DocumentSnapshot doc = await locator<FirebaseService>().getUserData(userId: _uuid);

    doc.data()['gamification_element_rating'].forEach((element){
      rates.add(element);
    });

    rates.add(_gamificationRateSubject.value);

    await locator<FirebaseService>().updateUserData(userId: _uuid, map: {
      'gamification_element_rating': rates,
    });

    setTimer();
    locator<NavigationService>().pop();
  }

  Future<dynamic> navigateToEditScreen() async {
    return locator<NavigationService>().pushNamed(CHANGE_USER_DETAILS_SCREEN);
  }

  void pop(){
    locator<NavigationService>().pop();
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
    _isDateTrueSubject.close();
    _gamificationRateSubject.close();
  }
}