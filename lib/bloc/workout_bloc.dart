import 'package:flex/bloc/base_bloc.dart';
import 'package:rxdart/rxdart.dart';

class WorkoutBloc extends BaseBloc {

  //Play and pause controls for the video player
  PublishSubject<bool> _playPauseVideo = PublishSubject<bool>();
  Stream<bool> get getPlayPauseVideoStream => _playPauseVideo.stream;
  Sink<bool> get getPlayPauseVideoSink => _playPauseVideo.sink;

  @override
  dispose() {
    _playPauseVideo.close();
  }

}