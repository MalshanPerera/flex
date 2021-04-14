import 'package:flex/bloc/home_screen_bloc.dart';
import 'package:flex/bloc/loading_bloc.dart';
import 'package:flex/helper/app_assets.dart';
import 'package:flex/helper/app_colors.dart';
import 'package:flex/helper/app_utils.dart';
import 'package:flex/widgets/loading_barrier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> _categoryList = [
    {
      'image': FULL_BODY_WORKOUT,
      'title': 'Full Body Workout',
    },
    {
      'image': ARMS_WORKOUT,
      'title': 'Arms Workout',
    },
    {
      'image': ABS_WORKOUT,
      'title': 'Abs Workout',
    },
  ];

  HomeScreenBloc _homeScreenBloc;
  LoadingBloc _loadingBloc;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(!_isLoaded){
      _homeScreenBloc = Provider.of<HomeScreenBloc>(context);
      _loadingBloc = Provider.of<LoadingBloc>(context);
      _homeScreenBloc.getUserData();
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
              key: _scaffoldKey,
              backgroundColor: BACKGROUND_COLOR,
              body: Padding(
                padding: EdgeInsets.only(left: Utils.getDesignWidth(26), top: Utils.getDesignHeight(20.0), right: Utils.getDesignWidth(26)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: Utils.getDesignHeight(10.0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: StreamBuilder(
                              stream: _homeScreenBloc.userDetailsStream,
                              builder: (context, AsyncSnapshot<UserDetails> snapshot) {
                                return Text(
                                  snapshot.hasData ? "Hello ${snapshot.data.name}" : "Hello Minh Q.N",
                                  style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 35.0,
                                  ),
                                  overflow: TextOverflow.fade,
                                );
                              }
                            ),
                          ),
                          CircleAvatar(
                            radius: 30.0,
                            backgroundImage:
                            NetworkImage(DEFAULT_AVATAR),
                            backgroundColor: PRIMARY_COLOR,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      _greeting(),
                      style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Utils.getDesignHeight(40.0)),
                      child: Text(
                        "Your Progression",
                        style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: Utils.getDesignHeight(15.0),),
                      padding: EdgeInsets.symmetric(
                        horizontal: Utils.getDesignWidth(20.0),
                        vertical: Utils.getDesignWidth(15.0),),
                      decoration: BoxDecoration(
                        color: PRIMARY_COLOR,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StreamBuilder(
                            stream: _homeScreenBloc.userDetailsStream,
                            builder: (context, AsyncSnapshot<UserDetails> snapshot) {
                              return _progressWidget(
                                title: "Arms Workout",
                                percent: snapshot.hasData ? snapshot.data.armsProgress : 0.0,
                                daysLeft: _getDaysLeft(snapshot.hasData ? snapshot.data.armsProgress : 0.0),
                              );
                            }
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: Utils.getDesignHeight(10.0),),
                            child: StreamBuilder(
                              stream: _homeScreenBloc.userDetailsStream,
                              builder: (context, AsyncSnapshot<UserDetails> snapshot) {
                                return _progressWidget(
                                    title: "Abs Workout",
                                    percent: snapshot.hasData ? snapshot.data.absProgress : 0.0,
                                    daysLeft: _getDaysLeft(snapshot.hasData ? snapshot.data.absProgress : 0.0),
                                );
                              }
                            ),
                          ),
                          StreamBuilder(
                            stream: _homeScreenBloc.userDetailsStream,
                            builder: (context, AsyncSnapshot<UserDetails> snapshot) {
                              return _progressWidget(
                                  title: "Full Body Workout",
                                  percent: snapshot.hasData ? snapshot.data.fullBodyProgress : 0.0,
                                  daysLeft: _getDaysLeft(snapshot.hasData ? snapshot.data.fullBodyProgress : 0.0),
                              );
                            }
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Utils.getDesignHeight(40.0)),
                      child: Text(
                        "Categories",
                        style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: Utils.getDesignHeight(10.0)),
                        itemCount: _categoryList.length,
                        itemBuilder: (BuildContext context, index){
                          return _categoriesListTile(
                            image: _categoryList[index]['image'],
                            title: _categoryList[index]['title'],
                            index: index,
                          );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        LoadingBarrier(_loadingBloc.isLoading),
      ],
    );
  }

  Widget _categoriesListTile({String image, String title, int index}){
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
              color: SHADOW_COLOR,
              offset: Offset(0, 0),
              blurRadius: 1,
            ),
          ],
        ),
        margin: const EdgeInsets.only(top: 10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          child: ListTile(
            tileColor: Colors.white,
            contentPadding: EdgeInsets.only(
              left: Utils.getDesignWidth(10.0),
              top: Utils.getDesignHeight(5.0),
              right: Utils.getDesignWidth(10.0),
              bottom: Utils.getDesignHeight(5.0),
            ),
            leading: SvgPicture.asset(
              image,
              height: Utils.getDesignHeight(45),
              width: Utils.getDesignWidth(45),
            ),
            title: Text(title),
            trailing: Icon(Icons.chevron_right_rounded, color: PRIMARY_COLOR,),
          ),
        ),
      ),
      onTap: () => _homeScreenBloc.navigateToWorkoutScreen(index),
    );
  }

  Widget _progressWidget({String title, double percent, String daysLeft}){
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
              color: Colors.white,
            ),
          ),
          Column(
            children: [
              LinearPercentIndicator(
                animation: true,
                animateFromLastPercent: true,
                animationDuration: 2,
                width: 140.0,
                lineHeight: 14.0,
                percent: percent,
                linearStrokeCap: LinearStrokeCap.roundAll,
                backgroundColor: Colors.white,
                progressColor: PINK,
              ),
              Text(
                "$daysLeft",
                style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                  fontSize: 15.0,
                  color: Colors.yellow,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getDaysLeft(double progress){

    String days = "14 Days Left";

    if(progress == 0.0714){
      days = "13 Days Left";
    }
    if(progress == 0.1428){
      days = "12 Days Left";
    }
    if(progress == 0.2142){
      days = "11 Days Left";
    }
    if(progress == 0.2856){
      days = "10 Days Left";
    }
    if(progress == 0.357){
      days = "09 Days Left";
    }
    if(progress == 0.4284){
      days = "08 Days Left";
    }
    if(progress == 0.4998){
      days = "07 Days Left";
    }
    if(progress == 0.5712){
      days = "06 Days Left";
    }
    if(progress == 0.6426){
      days = "05 Days Left";
    }
    if(progress == 0.714){
      days = "04 Days Left";
    }
    if(progress == 0.7854){
      days = "03 Days Left";
    }
    if(progress == 0.8568){
      days = "02 Days Left";
    }
    if(progress == 0.9282){
      days = "01 Days Left";
    }
    if(progress == 0.9996){
      days = "Done!!";
    }

    return days;
  }

  String _greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }
}
