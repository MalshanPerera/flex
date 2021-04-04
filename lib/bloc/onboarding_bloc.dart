import 'dart:async';

import 'package:flex/bloc/base_bloc.dart';
import 'package:flex/service_locator.dart';
import 'package:flex/services/navigation_service.dart';
import 'package:rxdart/rxdart.dart';

class OnBoardingBloc extends BaseBloc {

  BehaviorSubject<int> _pageViewSubject = BehaviorSubject<int>.seeded(0);
  Stream<int> get pageViewStream => _pageViewSubject.stream;
  Sink<int> get pageViewSink => _pageViewSubject.sink;

  void navigateToHomeScreen() {
    locator<NavigationService>().pushReplacement('/home_screen');
  }

  @override
  dispose() {
    _pageViewSubject.close();
  }


}