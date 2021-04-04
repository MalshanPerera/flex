import 'package:event_bus/event_bus.dart';
import 'package:flex/bloc/base_bloc.dart';
import 'package:flex/helper/load_events.dart';
import 'package:flex/service_locator.dart';
import 'package:flex/services/firebase_service.dart';
import 'package:rxdart/rxdart.dart';

class SignUpBloc extends BaseBloc {

  final _eventBus = locator<EventBus>();

  BehaviorSubject<int> _genderRadioBtnSubject = BehaviorSubject<int>();
  Stream<int> get genderRadioBtnStream => _genderRadioBtnSubject.stream;
  Sink<int> get genderRadioBtnSink => _genderRadioBtnSubject.sink;

  BehaviorSubject<int> _userTypeRadioBtnSubject = BehaviorSubject<int>();
  Stream<int> get userTypeRadioBtnStream => _userTypeRadioBtnSubject.stream;
  Sink<int> get userTypeRadioBtnSink => _userTypeRadioBtnSubject.sink;

  void signUp({String email, String password, String name, String gender, String userType}){

    _eventBus.fire(LoadEvent.show());
    locator<FirebaseService>().signUp(email, password, name, gender, userType).then((value) => {
      _eventBus.fire(LoadEvent.hide())
    });
  }

  @override
  dispose() {
    _genderRadioBtnSubject.close();
    _userTypeRadioBtnSubject.close();
  }

}