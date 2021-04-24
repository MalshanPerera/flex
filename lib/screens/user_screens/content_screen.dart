import 'package:flex/bloc/change_user_details_bloc.dart';
import 'package:flex/bloc/content_bloc.dart';
import 'package:flex/bloc/loading_bloc.dart';
import 'package:flex/helper/app_colors.dart';
import 'package:flex/helper/app_data.dart';
import 'package:flex/helper/app_enums.dart';
import 'package:flex/screens/user_screens/home_screen.dart';
import 'package:flex/screens/user_screens/leaderboard_screen.dart';
import 'package:flex/screens/user_screens/profile_screen.dart';
import 'package:flex/widgets/loading_barrier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentScreen extends StatefulWidget {
  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {

  final _appData = AppData.getInstance; //singleton network instance

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

      _isLoaded = true;
    }
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
