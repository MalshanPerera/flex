import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flex/helper/app_enums.dart';
import 'package:flex/service_locator.dart';
import 'package:flex/services/firebase_service.dart';
import 'package:flex/services/navigation_service.dart';
import 'package:flex/services/user_service.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class ContentScreenBloc {

  final _userService = locator<UserService>();

  String _uuid;

  BehaviorSubject<int> _navigationEventIndex = BehaviorSubject<int>.seeded(0);
  Stream<int> get navigationEvent => _navigationEventIndex.stream;
  StreamController<int> _navigationIndexController = StreamController();
  Sink<int> get setNavigationEvent => _navigationIndexController.sink;

  BehaviorSubject<int> _navigationEventIndexTwo = BehaviorSubject<int>.seeded(0);
  Stream<int> get navigationEventTwo => _navigationEventIndexTwo.stream;
  StreamController<int> _navigationIndexControllerTwo = StreamController();
  Sink<int> get setNavigationEventTwo => _navigationIndexControllerTwo.sink;

  BehaviorSubject<bool> _isDateTrueSubject = BehaviorSubject<bool>.seeded(true);
  Stream<bool> get getIsDateTrueStream => _isDateTrueSubject.stream;
  Sink<bool> get setIsDateTrueSink => _isDateTrueSubject.sink;

  BehaviorSubject<double> _gamificationRateSubject = BehaviorSubject<double>();
  Sink<double> get gamificationRateSink => _gamificationRateSubject.sink;

  BehaviorSubject<HomeTabs> _pageChanges = BehaviorSubject<HomeTabs>();
  Stream<HomeTabs> get pageChanged => _pageChanges.stream;

  BehaviorSubject<HomeTabsTwo> _pageTwoChanges = BehaviorSubject<HomeTabsTwo>();
  Stream<HomeTabsTwo> get pageTwoChanged => _pageTwoChanges.stream;

  ContentScreenBloc(){

    _navigationIndexController.stream.listen((index){
      _navigationEventIndex.add(index);
      _pageChanges.add(HomeTabs.values[index]);
    });

    _navigationIndexControllerTwo.stream.listen((index){
      _navigationEventIndexTwo.add(index);
      _pageTwoChanges.add(HomeTabsTwo.values[index]);
    });
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

  void pop(){
    locator<NavigationService>().pop();
  }

  void dispose(){
    _pageChanges.close();
    _pageTwoChanges.close();
    _navigationEventIndex.close();
    _navigationIndexController.close();
    _navigationEventIndexTwo.close();
    _navigationIndexControllerTwo.close();
    _isDateTrueSubject.close();
    _gamificationRateSubject.close();
  }

}