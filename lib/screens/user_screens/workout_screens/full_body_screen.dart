import 'dart:async';

import 'package:flex/bloc/workout_bloc.dart';
import 'package:flex/helper/app_colors.dart';
import 'package:flex/helper/app_enums.dart';
import 'package:flex/helper/app_utils.dart';
import 'package:flex/widgets/count_down.dart';
import 'package:flex/widgets/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class FullBodyWorkoutScreen extends StatefulWidget {
  @override
  _WorkoutScreenshotsState createState() => _WorkoutScreenshotsState();
}

class _WorkoutScreenshotsState extends State<FullBodyWorkoutScreen> with SingleTickerProviderStateMixin {

  WorkoutBloc _workoutBloc;
  AnimationController _controller;

  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(minutes: 13));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(!_isLoaded){
      _workoutBloc = Provider.of<WorkoutBloc>(context);
      _workoutBloc.getTimer();

      _isLoaded = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: BACKGROUND_COLOR,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: BACKGROUND_COLOR,
          body: Column(
            children: [
              StreamBuilder(
                initialData: false,
                stream: _workoutBloc.getPlayPauseVideoStream,
                builder: (context, snapshot) {
                  return VideoPlayerWidget(
                    videoPath: 'https://firebasestorage.googleapis.com/v0/b/flex-c7f0d.appspot.com/o/FullBody_Workout.mp4?alt=media&token=3ad07539-9652-43a7-8cb4-7b191c943e00',
                    videoType: VideoType.NETWORK,
                    isStarted: snapshot.data,
                  );
                }
              ),
              CountDown(
                animation: StepTween(
                  begin: 13 * 60,
                  end: 0,
                ).animate(_controller),
              ),
              StreamBuilder(
                initialData: false,
                stream: _workoutBloc.getPlayPauseVideoStream,
                builder: (context, snapshot) {
                  return GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: PRIMARY_COLOR,
                      ),
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        snapshot.data ? Icons.pause_sharp : Icons.play_arrow,
                        color: Colors.white,
                        size: 45,
                      ),
                    ),
                    onTap: () {
                      print(!snapshot.data);
                      if(snapshot.data){
                        _controller.stop();
                      }else{
                        _controller.forward();
                      }
                      _workoutBloc.getPlayPauseVideoSink.add(!snapshot.data);
                    },
                  );
                }
              ),
              Spacer(),
              StreamBuilder(
                stream: _workoutBloc.getIsDateTrueStream,
                  initialData: false,
                  builder: (context, snapshot) {
                  return snapshot.data ? Container(
                    margin: EdgeInsets.only(bottom: Utils.getDesignHeight(30.0)),
                    width: Utils.getDesignWidth(300),
                    child: Text(
                      "You did well today, Come tomorrow for the next session",
                      style: Theme.of(context).primaryTextTheme.button.copyWith(
                          color: PRIMARY_COLOR,
                        fontSize: 18.0
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ) : Container();
                }
              ),
              StreamBuilder(
                  stream: _workoutBloc.getIsDateTrueStream,
                  initialData: false,
                  builder: (context, snapshot) {
                    return Container(
                      margin: EdgeInsets.only(bottom: Utils.getDesignHeight(50.0)),
                      width: Utils.getDesignWidth(300),
                      height: Utils.getDesignHeight(50),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: snapshot.data ? Colors.transparent : PRIMARY_COLOR.withOpacity(0.2),
                            offset: Offset(0, 0,),
                            blurRadius: 21,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: PRIMARY_COLOR,
                          onPrimary: Colors.grey,
                          elevation: 0.0,
                        ),
                        child: Text(
                          "Finish Workout",
                          style: Theme.of(context).primaryTextTheme.button.copyWith(
                              color: Colors.white
                          ),
                        ),
                        onPressed: snapshot.data ? null : () {
                          _workoutBloc.setTimer();
                          _modalBottomSheetMenu();
                        },
                      ),
                    );
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _modalBottomSheetMenu(){
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      builder: (builder){
        return Container(
          height: Utils.getDesignHeight(300),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "How motivated are you right now",
                  style: Theme.of(context).primaryTextTheme.button.copyWith(
                    fontSize: 20.0,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: Utils.getDesignHeight(15.0)),
                child: Center(
                  child: RatingBar.builder(
                    itemSize: 60,
                    initialRating: 0,
                    itemCount: 5,
                    glow: false,
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return Icon(
                            Icons.sentiment_very_dissatisfied,
                            color: Colors.red,
                          );
                        case 1:
                          return Icon(
                            Icons.sentiment_dissatisfied,
                            color: Colors.redAccent,
                          );
                        case 2:
                          return Icon(
                            Icons.sentiment_neutral,
                            color: Colors.amber,
                          );
                        case 3:
                          return Icon(
                            Icons.sentiment_satisfied,
                            color: Colors.lightGreen,
                          );
                        case 4:
                          return Icon(
                            Icons.sentiment_very_satisfied,
                            color: Colors.green,
                          );
                        default:
                          return Icon(
                            Icons.sentiment_very_satisfied,
                            color: Colors.green,
                          );
                      }
                    },
                    onRatingUpdate: (rating) => _workoutBloc.motivationRateSink.add(rating),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: Utils.getDesignHeight(15.0)),
                width: Utils.getDesignWidth(300),
                height: Utils.getDesignHeight(50),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: PRIMARY_COLOR.withOpacity(0.2),
                      offset: Offset(0, 0,),
                      blurRadius: 21,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: PRIMARY_COLOR,
                    onPrimary: Colors.grey,
                    elevation: 0.0,
                  ),
                  child: Text(
                    "Rate this Exercise",
                    style: Theme.of(context).primaryTextTheme.button.copyWith(
                        color: Colors.white
                    ),
                  ),
                  onPressed: () => _workoutBloc.setMotivationRate(WorkoutType.FULL_BODY),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: Utils.getDesignHeight(15.0)),
                width: Utils.getDesignWidth(300),
                height: Utils.getDesignHeight(50),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    onPrimary: Colors.transparent,
                    elevation: 0.0,
                  ),
                  child: Text(
                    "Go Back",
                    style: Theme.of(context).primaryTextTheme.button.copyWith(
                      color: PRIMARY_COLOR,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onPressed: () => _workoutBloc.navigateToHomeScreen(),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

