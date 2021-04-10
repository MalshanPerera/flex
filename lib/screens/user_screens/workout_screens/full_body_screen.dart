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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(minutes: 13));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _workoutBloc = Provider.of<WorkoutBloc>(context);
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
              Container(
                margin: EdgeInsets.only(bottom: Utils.getDesignHeight(50.0)),
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
                    "Finish Workout",
                    style: Theme.of(context).primaryTextTheme.button.copyWith(
                        color: Colors.white
                    ),
                  ),
                  onPressed: () => showAlertDialog(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
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
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                },
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
              onPressed: () => showAlertDialog(context),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: Utils.getDesignHeight(15.0)),
            width: Utils.getDesignWidth(300),
            height: Utils.getDesignHeight(50),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: SHADOW_COLOR,
                  offset: Offset(0, 0,),
                  blurRadius: 21,
                ),
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.grey,
                elevation: 0.0,
              ),
              child: Text(
                "Back to Home Screen",
                style: Theme.of(context).primaryTextTheme.button.copyWith(
                    color: PRIMARY_COLOR
                ),
              ),
              onPressed: () => showAlertDialog(context),
            ),
          ),
        ],
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

