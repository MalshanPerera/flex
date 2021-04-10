import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flex/bloc/base_bloc.dart';
import 'package:flex/helper/load_events.dart';
import 'package:flex/service_locator.dart';
import 'package:flex/services/firebase_service.dart';
import 'package:flex/services/user_service.dart';
import 'package:rxdart/rxdart.dart';

class LeaderboardBloc extends BaseBloc {

  final _eventBus = locator<EventBus>();
  final _userService = locator<UserService>();

  BehaviorSubject<List<LeaderboardDetails>> _leaderboardDetailsSubject = BehaviorSubject<List<LeaderboardDetails>>();
  Stream<List<LeaderboardDetails>> get leaderboardDetailsStream => _leaderboardDetailsSubject.stream;
  Sink<List<LeaderboardDetails>> get leaderboardDetailsSink => _leaderboardDetailsSubject.sink;

  void getLeaderboardData() async {

    List<LeaderboardDetails> _temp = [];

    _eventBus.fire(LoadEvent.show());
    QuerySnapshot doc = await locator<FirebaseService>().getLeaderboardData().whenComplete(() {
      _eventBus.fire(LoadEvent.hide());
    });

    doc.docs.forEach((data){
      _temp.add(LeaderboardDetails(data));
    });

    leaderboardDetailsSink.add(_temp);
    print(doc.docs[0].data());
  }

  @override
  dispose() {
    _leaderboardDetailsSubject.close();
  }

}

class LeaderboardDetails {

  String uid;
  String name;
  int points;

  LeaderboardDetails(key){
    uid = key['uid'];
    name = key['name'];
    points = key['points'];
  }
}