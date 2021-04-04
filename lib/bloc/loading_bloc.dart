import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flex/bloc/base_bloc.dart';
import 'package:flex/helper/load_events.dart';
import 'package:flex/service_locator.dart';
import 'package:rxdart/rxdart.dart';

class LoadingBloc extends BaseBloc {

  StreamSubscription _eventSub;
  BehaviorSubject<bool> _controller = BehaviorSubject();

  LoadingBloc(){
    _eventSub = locator<EventBus>().on<LoadEvent>().listen((event) {
      _controller.add(event.isLoading);
    });
  }

  @override
  void dispose() {
    _controller.close();
    _eventSub.cancel();
  }

  Stream<bool> get isLoading => _controller.stream;

}