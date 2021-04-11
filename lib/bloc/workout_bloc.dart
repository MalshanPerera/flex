import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flex/bloc/base_bloc.dart';
import 'package:flex/helper/app_enums.dart';
import 'package:flex/helper/load_events.dart';
import 'package:flex/service_locator.dart';
import 'package:flex/services/firebase_service.dart';
import 'package:flex/services/user_service.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class WorkoutBloc extends BaseBloc {

  final _userService = locator<UserService>();
  final _eventBus = locator<EventBus>();

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
  }

  void getTimer() async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String dateNow = formatter.format(now);

    String setDate = await _userService.getDate;

    if(dateNow == setDate || setDate != null){
      setIsDateTrueSink.add(true);
    }else{
      setIsDateTrueSink.add(false);
    }
  }

  void setMotivationRate(WorkoutType workoutType) async {

    double progress;
    int expPoints;
    int points;
    List<double> rates = [];

    String _uuid = await _userService.getUserId;

    _eventBus.fire(LoadEvent.show());
    DocumentSnapshot doc = await locator<FirebaseService>().getUserData(userId: _uuid);

    progress = workoutType == WorkoutType.ABS ? doc.data()["abs_progress"] : workoutType == WorkoutType.ARMS ? doc.data()["arms_progress"] : doc.data()["full_body_progress"];
    progress = doc.data()["expPoints"];
    progress = doc.data()["points"];

    doc.data()["motivation_rating"].forEach((rate){
      rates.add(rate);
    });

    rates.add(_motivationRateSubject.value);

    bool model = await locator<FirebaseService>().setMotivationRate(uid: _uuid, map: {
      'motivation_rating': rates,
      '${workoutType == WorkoutType.ABS ? 'abs_progress' : workoutType == WorkoutType.ARMS ? 'arms_progress' : 'full_body_progress'}': progress + 0.714,
      'expPoints': expPoints + 10,
      'points': points + 10,
    });
    _eventBus.fire(LoadEvent.hide());

    print(model);
    print(doc.data()["motivation_rating"]);
    print(rates);
  }

  @override
  dispose() {
    _playPauseVideo.close();
    _motivationRateSubject.close();
    _isDateTrueSubject.close();
  }

}