import 'dart:async';

import 'package:flex/helper/app_enums.dart';
import 'package:rxdart/rxdart.dart';

class ContentScreenBloc {

  BehaviorSubject<int> _navigationEventIndex = BehaviorSubject<int>.seeded(0);
  Stream<int> get navigationEvent => _navigationEventIndex.stream;
  StreamController<int> _navigationIndexController = StreamController();
  Sink<int> get setNavigationEvent => _navigationIndexController.sink;

  BehaviorSubject<int> _navigationEventIndexTwo = BehaviorSubject<int>.seeded(0);
  Stream<int> get navigationEventTwo => _navigationEventIndexTwo.stream;
  StreamController<int> _navigationIndexControllerTwo = StreamController();
  Sink<int> get setNavigationEventTwo => _navigationIndexControllerTwo.sink;

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

  void dispose(){
    _pageChanges.close();
    _pageTwoChanges.close();
    _navigationEventIndex.close();
    _navigationIndexController.close();
    _navigationEventIndexTwo.close();
    _navigationIndexControllerTwo.close();
  }

}