import 'package:flex/bloc/home_screen_bloc.dart';
import 'package:flex/bloc/loading_bloc.dart';
import 'package:flex/bloc/profile_bloc.dart';
import 'package:flex/helper/app_assets.dart';
import 'package:flex/helper/app_colors.dart';
import 'package:flex/helper/app_utils.dart';
import 'package:flex/widgets/loading_barrier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  ProfileBloc _profileBloc;
  LoadingBloc _loadingBloc;

  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(!_isLoaded){
      _profileBloc = Provider.of<ProfileBloc>(context);
      _loadingBloc = Provider.of<LoadingBloc>(context);

      _profileBloc.getUserData();

      _isLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: BACKGROUND_COLOR,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: BACKGROUND_COLOR,
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: Utils.getDesignWidth(26), top: Utils.getDesignHeight(20.0), right: Utils.getDesignWidth(26), bottom: Utils.getDesignHeight(20.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.logout,
                                    color: Colors.transparent,
                                    size: 25.0,
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 70.0,
                                  backgroundImage:
                                  NetworkImage(DEFAULT_AVATAR),
                                  backgroundColor: Colors.white,
                                ),
                                GestureDetector(
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.logout,
                                      color: PRIMARY_COLOR,
                                      size: 25.0,
                                    ),
                                  ),
                                  onTap: () => _profileBloc.logout(),
                                ),
                              ],
                            ),
                            StreamBuilder(
                              stream: _profileBloc.userDetailsStream,
                              builder: (context, AsyncSnapshot<UserDetails> snapshot) {
                                return snapshot.hasData ? Column(
                                  children: [
                                    Text(
                                      snapshot.data.name,
                                      style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 35.0,
                                      ),
                                      overflow: TextOverflow.fade,
                                    ),
                                    Text(
                                      _level(snapshot.data.expPoints) == 10 ? "Platinum Player" : "Level ${_level(snapshot.data.expPoints)}",
                                      style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                      ),
                                      overflow: TextOverflow.fade,
                                    ),
                                  ],
                                ) : Container();
                              }
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: Utils.getDesignHeight(20.0)),
                          padding: EdgeInsets.symmetric(vertical: Utils.getDesignHeight(5.0)),
                          width: Utils.getDesignWidth(150),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  StreamBuilder(
                                    stream: _profileBloc.userDetailsStream,
                                    builder: (context, AsyncSnapshot<UserDetails> snapshot) {
                                      return Text(
                                        "${snapshot.hasData ? snapshot.data.weight : 0} kg",
                                        style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0,
                                        ),
                                        overflow: TextOverflow.fade,
                                      );
                                    }
                                  ),
                                  Text(
                                    "Weight",
                                    style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                    ),
                                    overflow: TextOverflow.fade,
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: PINK,
                                ),
                              ),
                              Column(
                                children: [
                                  StreamBuilder(
                                    stream: _profileBloc.userDetailsStream,
                                    builder: (context, AsyncSnapshot<UserDetails> snapshot) {
                                      return Text(
                                        "${snapshot.hasData ? snapshot.data.height : 0} feets",
                                        style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0,
                                        ),
                                        overflow: TextOverflow.fade,
                                      );
                                    }
                                  ),
                                  Text(
                                    "Height",
                                    style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                    ),
                                    overflow: TextOverflow.fade,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Utils.getDesignHeight(30.0),),
                        child: Text(
                          "Achievements & Badges",
                          style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Utils.getDesignHeight(10.0),),
                        child: StreamBuilder(
                          stream: _profileBloc.userDetailsStream,
                          builder: (context, AsyncSnapshot<UserDetails> snapshot) {
                            return _achievementBadgesWidget(snapshot.hasData ? snapshot.data.achievementsList : []);
                          }
                        ),
                      ),
                      // StreamBuilder(
                      //   stream: _profileBloc.userDetailsStream,
                      //   builder: (context, AsyncSnapshot<UserDetails> snapshot) {
                      //     return snapshot.hasData && snapshot.data.achievementsList.isNotEmpty ? SingleChildScrollView(
                      //       scrollDirection: Axis.horizontal,
                      //       child: Row(
                      //         children: snapshot.data.achievementsList.map((id) {
                      //           return _achievementBadgesWidget(id);
                      //         }).toList(),
                      //       ),
                      //     ) :_noDataWidgets(text: "No Achievements");
                      //   }
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        LoadingBarrier(_loadingBloc.isLoading),
      ],
    );
  }

  int _level(int expPoints){

    int level = 1;

    if(expPoints == 30){
      level = 2;
    }
    if(expPoints == 60){
      level = 3;
    }
    if(expPoints == 90){
      level = 4;
    }
    if(expPoints == 120){
      level = 5;
    }
    if(expPoints == 150){
      level = 6;
    }
    if(expPoints == 180){
      level = 7;
    }
    if(expPoints == 210){
      level = 8;
    }
    if(expPoints == 240){
      level = 9;
    }
    if(expPoints >= 270){
      level = 10;
    }

    return level;
  }

  Widget _achievementBadgesWidget(List<String> achievementList){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _customContainer(image: FIRST_DAY, text: "First Day", isAchieved: achievementList.contains("First Day"),),
            _customContainer(image: FIVE_DAY, text: "Exercise for 5 days Straight", isAchieved: achievementList.contains("Exercise for 5 days Straight"),),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: Utils.getDesignHeight(20.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _customContainer(image: TEN_DAY, text: "Exercise for 10 days Straight", isAchieved: achievementList.contains("Exercise for 10 days Straight"),),
              _customContainer(image: FINISH, text: "Finish 14 days Challenge", isAchieved: achievementList.contains("Finish 14 days Challenge"),),
            ],
          ),
        ),
      ],
    );
  }

  Widget _customContainer({String image, String text, bool isAchieved}){
    return Stack(
      children: [
        Container(
          height: Utils.getDesignHeight(150),
          width: Utils.getDesignWidth(150),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                image,
                height: Utils.getDesignHeight(50),
                width: Utils.getDesignWidth(50),
              ),
              Container(
                margin: EdgeInsets.only(top: Utils.getDesignHeight(10.0)),
                width: Utils.getDesignWidth(60),
                child: Text(
                  text,
                  style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 11.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        !isAchieved ? Container(
          height: Utils.getDesignHeight(150),
          width: Utils.getDesignWidth(150),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.withOpacity(0.7),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline_rounded,
                size: 50,
              ),
              Container(
                margin: EdgeInsets.only(top: Utils.getDesignHeight(10.0)),
                width: Utils.getDesignWidth(60),
              ),
            ],
          ),
        ) : Container(),
      ],
    );
  }
}
