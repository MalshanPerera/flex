import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flex/bloc/base_bloc.dart';
import 'package:flex/helper/app_enums.dart';
import 'package:flex/helper/app_routes.dart';
import 'package:flex/helper/load_events.dart';
import 'package:flex/service_locator.dart';
import 'package:flex/services/firebase_service.dart';
import 'package:flex/services/navigation_service.dart';
import 'package:flex/services/user_service.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class WorkoutBloc extends BaseBloc {

  final _userService = locator<UserService>();
  final _eventBus = locator<EventBus>();

  int _achievementDays = 0;

  //Play and pause controls for the video player
  PublishSubject<bool> _playPauseVideo = PublishSubject<bool>();
  Stream<bool> get getPlayPauseVideoStream => _playPauseVideo.stream;
  Sink<bool> get getPlayPauseVideoSink => _playPauseVideo.sink;

  BehaviorSubject<double> _motivationRateSubject = BehaviorSubject<double>();
  Sink<double> get motivationRateSink => _motivationRateSubject.sink;

  PublishSubject<bool> _isDateTrueSubject = PublishSubject<bool>();
  Stream<bool> get getIsDateTrueStream => _isDateTrueSubject.stream;
  Sink<bool> get setIsDateTrueSink => _isDateTrueSubject.sink;

  void setTimer() async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String date = formatter.format(now);

    _userService.saveDate(date);
    getTimer();
    setAchievements();
  }

  void getTimer() async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String dateNow = formatter.format(now);

    String setDate = await _userService.getDate;

    if(dateNow.contains(setDate ?? "") && setDate != null){
      setIsDateTrueSink.add(true);

    }else{
      setIsDateTrueSink.add(false);
    }
  }

  void navigateToHomeScreenPop(){
    locator<NavigationService>().pop();
  }

  void navigateToHomeScreen(){
    locator<NavigationService>().pushReplacement(HOME_SCREEN);
  }

  void setMotivationRate(WorkoutType workoutType) async {

    double progress = 0.0;
    int expPoints = 0;
    int points = 0;
    List<double> rates = [];

    String _uuid = await _userService.getUserId;

    _eventBus.fire(LoadEvent.show());
    DocumentSnapshot doc = await locator<FirebaseService>().getUserData(userId: _uuid);

    progress = workoutType == WorkoutType.ABS ? doc.data()["abs_progress"].toDouble() : workoutType == WorkoutType.ARMS ? doc.data()["arms_progress"].toDouble() : doc.data()["full_body_progress"].toDouble();
    progress = doc.data()["expPoints"].toDouble();
    // progress = doc.data()["points"];

    doc.data()["motivation_rating"].forEach((rate){
      rates.add(rate);
    });

    QuerySnapshot leaderboard = await locator<FirebaseService>().getLeaderboardData();

    QueryDocumentSnapshot _leaderboardMap = leaderboard.docs.firstWhere((element) => element.data()['uid'] == _uuid);

    points = _leaderboardMap.data()['points'];

    rates.add(_motivationRateSubject.value);

    bool leaderboardModel = await locator<FirebaseService>().updateLeaderboardData(uid: _uuid, map: {
      'points': points + 10,
    });

    bool model = await locator<FirebaseService>().setMotivationRate(uid: _uuid, map: {
      'motivation_rating': rates,
      '${workoutType == WorkoutType.ABS ? 'abs_progress' : workoutType == WorkoutType.ARMS ? 'arms_progress' : 'full_body_progress'}': progress + 0.0714,
      'expPoints': expPoints + 10,
      'points': points + 10,
    });
    _eventBus.fire(LoadEvent.hide());

    locator<NavigationService>().pushReplacement(HOME_SCREEN);
  }

  void getAchievements() async {
    _achievementDays = await _userService.getAchievement;
  }

  void setAchievements() async {

    String _uuid = await _userService.getUserId;

    List<String> _achievementList = [];

    _achievementDays = _achievementDays + 1;
    _userService.setAchievement(_achievementDays);

    DocumentSnapshot doc = await locator<FirebaseService>().getUserData(userId: _uuid);

    print(doc.data());
    print(doc.data()["achievement"]);

    if(doc.data()["achievement"] != null){
      doc.data()["achievement"].forEach((id){
        _achievementList.add(id);
      });
    }

    if(_achievementDays == 1){
      _achievementList.add("First Day");
      print("FIRST DAY");
    }

    if(_achievementDays == 5){
      _achievementList.add("Exercise for 5 days Straight");
      print("EXERCISE FOR 5 DAYS");
    }

    if(_achievementDays == 10){
      _achievementList.add("Exercise for 10 days Straight");
      print("EXERCISE FOR 10 DAYS");
    }

    if(_achievementDays == 14){
      _achievementList.add("Finish 14 days Challenge");
      print("COMPLETE 14 DAYS CHALLENGE");
    }

    bool achievement = await locator<FirebaseService>().setAchievement(uid: _uuid, map: {
      'achievement': _achievementList,
    });

    print("achievement: $achievement");

    // List<String> _ach = ["Complete 14 days Challenge", "Exercise for 5 days Straight", "Exercise for 10 days Straight", "First Day"];
    // List<String> _badges = ["Weight Lost Master", "No Pain No Gain", "Gainz for Dayz", "I am Iron Man"];
  }

  void setBadges() async {

  }

  @override
  dispose() {
    _playPauseVideo.close();
    _motivationRateSubject.close();
    _isDateTrueSubject.close();
  }

}