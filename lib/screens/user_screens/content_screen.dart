import 'dart:async';

import 'package:flex/bloc/change_user_details_bloc.dart';
import 'package:flex/bloc/content_bloc.dart';
import 'package:flex/bloc/loading_bloc.dart';
import 'package:flex/helper/app_colors.dart';
import 'package:flex/helper/app_data.dart';
import 'package:flex/helper/app_enums.dart';
import 'package:flex/helper/app_utils.dart';
import 'package:flex/screens/user_screens/home_screen.dart';
import 'package:flex/screens/user_screens/leaderboard_screen.dart';
import 'package:flex/screens/user_screens/profile_screen.dart';
import 'package:flex/widgets/loading_barrier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ContentScreen extends StatefulWidget {
  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {

  final _appData = AppData.getInstance; //singleton network instance

  StreamSubscription _streamSubscription;
  Stream<bool> _stream;

  ContentScreenBloc _contentScreenBloc;
  ChangeUserDetailsBloc _changeUserDetailsBloc;
  LoadingBloc _loadingBloc;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(!_isLoaded){
      _contentScreenBloc = Provider.of<ContentScreenBloc>(context);
      _changeUserDetailsBloc = Provider.of<ChangeUserDetailsBloc>(context);
      _loadingBloc = Provider.of<LoadingBloc>(context);

      _changeUserDetailsBloc.getUserData();
      _contentScreenBloc.getTimer();

      _isLoaded = true;
    }

    if (_stream != _contentScreenBloc.getIsDateTrueStream) {
      _stream = _contentScreenBloc.getIsDateTrueStream;
      _streamSubscription?.cancel();
      listenPageState(_contentScreenBloc.getIsDateTrueStream);
    }
  }

  void listenPageState(Stream<bool> stream) {
    _streamSubscription = stream.listen((isToday){
      if(!isToday){
        Future.delayed(Duration(seconds: 2));
        showDialogBox();
      }
    });
  }

  showDialogBox({bool isDismissible = true}) {
    showDialog(
      context: context,
      barrierDismissible: isDismissible,
      builder: (_) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20.0),
              child: Text('How would you rate the Game Elements',
                style: Theme.of(context).primaryTextTheme.button.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            RatingBar.builder(
              initialRating: 0,
              itemCount: 5,
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
              onRatingUpdate: (rating) => _contentScreenBloc.gamificationRateSink.add(rating),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30.0),
                  height: Utils.getDesignHeight(40),
                  width: Utils.getDesignWidth(100),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                    ),
                    onPressed: () => _contentScreenBloc.pop(),
                    child: Text(
                      "Skip",
                      style: Theme.of(context).primaryTextTheme.button.copyWith(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30.0),
                  height: Utils.getDesignHeight(40),
                  width: Utils.getDesignWidth(100),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                    ),
                    onPressed: () => _contentScreenBloc.setUserData(),
                    child: Text(
                      "Rate",
                      style: Theme.of(context).primaryTextTheme.button.copyWith(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: 0,
      stream: _changeUserDetailsBloc.tabIndexStream,
      builder: (context, snapshotIndex) {
        print(snapshotIndex.data);
        return _appData.leaderboard != null ? Stack(
          children: [
            Container(
              color: BACKGROUND_COLOR,
              child: SafeArea(
                bottom: false,
                child: Scaffold(
                  backgroundColor: BACKGROUND_COLOR,
                  body: _appData.leaderboard ? StreamBuilder(
                    initialData: HomeTabs.HOME,
                    stream: _contentScreenBloc.pageChanged,
                    builder: (context, AsyncSnapshot<HomeTabs> contentSnapshot){
                      switch (contentSnapshot.data) {
                        case HomeTabs.HOME:
                          return HomeScreen();
                        case HomeTabs.LEADERBOARD:
                          return LeaderBoardScreen();
                        case HomeTabs.PROFILE:
                          return ProfileScreen();
                        default:
                          return Container();
                      }
                    },
                  ) : StreamBuilder(
                    initialData: HomeTabsTwo.HOME,
                    stream: _contentScreenBloc.pageTwoChanged,
                    builder: (context, AsyncSnapshot<HomeTabsTwo> contentSnapshot){
                      switch (contentSnapshot.data) {
                        case HomeTabsTwo.HOME:
                          return HomeScreen();
                        case HomeTabsTwo.PROFILE:
                          return ProfileScreen();
                        default:
                          return Container();
                      }
                    },
                  ),
                  bottomNavigationBar: BottomNavigationBar(
                    currentIndex: snapshotIndex.data,
                    selectedItemColor: PRIMARY_COLOR,
                    items: _appData.leaderboard ? [
                      BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.home),
                        label: ("Home"),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.leaderboard),
                        label: ("Leaderboard"),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.profile_circled),
                        label: ("Profile"),
                      ),
                    ] : [
                      BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.home),
                        label: ("Home"),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.profile_circled),
                        label: ("Profile"),
                      ),
                    ],
                    onTap: (index) {
                      _appData.leaderboard ? _contentScreenBloc.setNavigationEvent.add(index) : _contentScreenBloc.setNavigationEventTwo.add(index);
                      _changeUserDetailsBloc.tabIndexSink.add(index);
                    },
                  ),
                ),
              ),
            ),
            LoadingBarrier(_loadingBloc.isLoading),
          ],
        ) : Container();
      }
    );
  }
}
