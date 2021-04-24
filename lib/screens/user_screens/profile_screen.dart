import 'package:flex/bloc/home_screen_bloc.dart';
import 'package:flex/bloc/profile_bloc.dart';
import 'package:flex/helper/app_assets.dart';
import 'package:flex/helper/app_colors.dart';
import 'package:flex/helper/app_data.dart';
import 'package:flex/helper/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:im_stepper/stepper.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  ProfileBloc _profileBloc;

  bool _isLoaded = false;

  final _appData = AppData.getInstance; //singleton network instance

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(!_isLoaded){
      _profileBloc = Provider.of<ProfileBloc>(context);
      _profileBloc.getUserData();
      _isLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: Utils.getDesignWidth(26), top: Utils.getDesignHeight(20.0), right: Utils.getDesignWidth(26), bottom: Utils.getDesignHeight(20.0)),
          child: StreamBuilder(
              stream: _profileBloc.userDetailsStream,
              builder: (context, AsyncSnapshot<UserDetails> snapshot) {
                return snapshot.hasData ? Column(
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
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 70.0,
                                    backgroundImage:
                                    NetworkImage(DEFAULT_AVATAR),
                                    backgroundColor: Colors.white,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      child: CircleAvatar(
                                        radius: 18.0,
                                        child: Icon(Icons.edit),
                                        backgroundColor: Colors.white,
                                      ),
                                      onTap: () {
                                        _refreshNavigator();
                                      },
                                    ),
                                  ),
                                ],
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
                          _appData.level ? StreamBuilder(
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
                                    _appData.level ? Text(
                                      _level(snapshot.data.expPoints) == 10 ? "Platinum Player" : "Level ${_level(snapshot.data.expPoints)}",
                                      style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                      ),
                                      overflow: TextOverflow.fade,
                                    ) : Container(),
                                    _exp(snapshot.data.expPoints).contains("Full") || !snapshot.data.elements.level ? Container() : Text(
                                      _exp(snapshot.data.expPoints),
                                      style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                      ),
                                      overflow: TextOverflow.fade,
                                    ),
                                  ],
                                ) : Container();
                              }
                          ) : Container(),
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
                    _appData.achievementsBadges ? Padding(
                      padding: EdgeInsets.only(top: Utils.getDesignHeight(30.0),),
                      child: Text(
                        "Achievements & Badges",
                        style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                      ),
                    ) : Container(),
                    _appData.achievementsBadges  ? Padding(
                      padding: EdgeInsets.only(top: Utils.getDesignHeight(10.0),),
                      child: StreamBuilder(
                          stream: _profileBloc.userDetailsStream,
                          builder: (context, AsyncSnapshot<UserDetails> snapshot) {
                            return _achievementBadgesWidget(snapshot.hasData ? snapshot.data.achievementsList : []);
                          }
                      ),
                    ) : Container(),
                    _appData.story ? Padding(
                      padding: EdgeInsets.only(top: Utils.getDesignHeight(30.0),),
                      child: Text(
                        "Story Line",
                        style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                      ),
                    ) : Container(),
                    _appData.story ? Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.withOpacity(0.5))
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: Utils.getDesignHeight(10.0),
                        horizontal: Utils.getDesignWidth(10.0),
                      ),
                      margin: EdgeInsets.only(top: Utils.getDesignHeight(10.0),),
                      child: Text(
                        "Godzila has declared war against you. It is the king of monsters. To battle him finish the 14 day challenge or you will be crushed by Godzila",
                        style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                          fontSize: 14.0,
                          color: PRIMARY_COLOR,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ) : Container(),
                    _appData.story ? StreamBuilder(
                        stream: _profileBloc.userDetailsStream,
                        builder: (context, AsyncSnapshot<UserDetails> snapshot) {

                          if(snapshot.hasData){
                            if(snapshot.data.step == 13){
                              return Container(
                                color: Colors.green,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    vertical: Utils.getDesignHeight(15)
                                ),
                                child: Text(
                                  "Story Completed",
                                  style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }else{
                              return _storyWidget(
                                activeStep: snapshot.data.step,
                              );
                            }
                          }else{
                            return Container();
                          }
                        }
                    ) : Container(),
                  ],
                ): Container();
              }
          ),
        ),
      ),
    );
  }

  Widget _storyWidget({int activeStep}){
    return Container(
      child: IconStepper(
        activeStepBorderColor: Colors.deepPurpleAccent,
        activeStepColor: PRIMARY_COLOR,
        icons: [
          activeStep == 0 ? Icon(Icons.forward, color: Colors.white,) : Icon(Icons.done_outline_rounded, color: Colors.white,),
          activeStep == 1 ? Icon(Icons.forward, color: Colors.white,) : activeStep < 2 ? Icon(Icons.clear, color: Colors.white,) : Icon(Icons.done_outline_rounded, color: Colors.white,),
          activeStep == 2 ? Icon(Icons.forward, color: Colors.white,) : activeStep < 3 ? Icon(Icons.clear, color: Colors.white,) : Icon(Icons.done_outline_rounded, color: Colors.white,),
          activeStep == 3 ? Icon(Icons.forward, color: Colors.white,) : activeStep < 4 ? Icon(Icons.clear, color: Colors.white,) : Icon(Icons.done_outline_rounded, color: Colors.white,),
          activeStep == 4 ? Icon(Icons.forward, color: Colors.white,) : activeStep < 5 ? Icon(Icons.clear, color: Colors.white,) : Icon(Icons.done_outline_rounded, color: Colors.white,),
          activeStep == 5 ? Icon(Icons.forward, color: Colors.white,) : activeStep < 6 ? Icon(Icons.clear, color: Colors.white,) : Icon(Icons.done_outline_rounded, color: Colors.white,),
          activeStep == 6 ? Icon(Icons.forward, color: Colors.white,) : activeStep < 7 ? Icon(Icons.clear, color: Colors.white,) : Icon(Icons.done_outline_rounded, color: Colors.white,),
          activeStep == 7 ? Icon(Icons.forward, color: Colors.white,) : activeStep < 8 ? Icon(Icons.clear, color: Colors.white,) : Icon(Icons.done_outline_rounded, color: Colors.white,),
          activeStep == 8 ? Icon(Icons.forward, color: Colors.white,) : activeStep < 9 ? Icon(Icons.clear, color: Colors.white,) : Icon(Icons.done_outline_rounded, color: Colors.white,),
          activeStep == 9 ? Icon(Icons.forward, color: Colors.white,) : activeStep < 10 ? Icon(Icons.clear, color: Colors.white,) : Icon(Icons.done_outline_rounded, color: Colors.white,),
          activeStep == 10 ? Icon(Icons.forward, color: Colors.white,) : activeStep < 11 ? Icon(Icons.clear, color: Colors.white,) : Icon(Icons.done_outline_rounded, color: Colors.white,),
          activeStep == 11 ? Icon(Icons.forward, color: Colors.white,) : activeStep < 12 ? Icon(Icons.clear, color: Colors.white,) : Icon(Icons.done_outline_rounded, color: Colors.white,),
          activeStep == 12 ? Icon(Icons.forward, color: Colors.white,) : activeStep < 13 ? Icon(Icons.clear, color: Colors.white,) : Icon(Icons.done_outline_rounded, color: Colors.white,),
          activeStep == 13 ? Icon(Icons.forward, color: Colors.white,) : activeStep < 14 ? Icon(Icons.clear, color: Colors.white,) : Icon(Icons.done_outline_rounded, color: Colors.white,),
        ],
        activeStep: activeStep,
        onStepReached: (index) {
          setState(() {});
        },
      ),
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

  String _exp(int expPoints){

    String level = "$expPoints/30";


    if(expPoints > 30 && expPoints < 60){
      level = "$expPoints/60";
    }
    if(expPoints > 60 && expPoints < 90){
      level = "$expPoints/90";
    }
    if(expPoints > 90 && expPoints < 120){
      level = "$expPoints/120";
    }
    if(expPoints > 120 && expPoints < 150){
      level = "$expPoints/150";
    }
    if(expPoints > 150 && expPoints < 180){
      level = "$expPoints/180";
    }
    if(expPoints > 180 && expPoints < 210){
      level = "$expPoints/210";
    }
    if(expPoints > 210 && expPoints < 240){
      level = "$expPoints/240";
    }
    if(expPoints > 240 && expPoints < 270){
      level = "$expPoints/270";
    }
    if(expPoints >= 270){
      level = "Full";
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

  void _refreshNavigator() async {

    var response = await _profileBloc.navigateToEditScreen();

    if((response != null && response) || response == null){
      _profileBloc.getUserData();
    }
  }
}
