import 'package:flex/bloc/profile_bloc.dart';
import 'package:flex/helper/app_colors.dart';
import 'package:flex/helper/app_data.dart';
import 'package:flex/helper/app_enums.dart';
import 'package:flex/screens/user_screens/home_screen.dart';
import 'package:flex/screens/user_screens/leaderboard_screen.dart';
import 'package:flex/screens/user_screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class ContentScreen extends StatefulWidget {
  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {

  PersistentTabController _controller;
  ProfileBloc _profileBloc;

  final _appData = AppData.getInstance; //singleton network instance

  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _controller = PersistentTabController(initialIndex: 0);

    if(!_isLoaded){
      _profileBloc = Provider.of<ProfileBloc>(context);

      _profileBloc.getUserData();

      _isLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {

    print(_appData.userTypes);
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _appData.userTypes == UserTypes.KILLER || _appData.userTypes == UserTypes.ACHIEVER ? _buildScreens() : _buildScreensSecond(),
      items: _appData.userTypes == UserTypes.KILLER || _appData.userTypes == UserTypes.ACHIEVER ? _navBarsItems() : _navBarsItemsSecond(),
      confineInSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: false, // Default is true.
      hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: false,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style12, // Choose the nav bar style with this property.
    );
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      LeaderBoardScreen(),
      ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home),
        title: ("Home"),
        activeColorPrimary: PRIMARY_COLOR,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.leaderboard),
        title: ("Leaderboard"),
        activeColorPrimary: PRIMARY_COLOR,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.profile_circled),
        title: ("Profile"),
        activeColorPrimary: PRIMARY_COLOR,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  List<Widget> _buildScreensSecond() {
    return [
      HomeScreen(),
      ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItemsSecond() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home),
        title: ("Home"),
        activeColorPrimary: PRIMARY_COLOR,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.profile_circled),
        title: ("Profile"),
        activeColorPrimary: PRIMARY_COLOR,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }


}
