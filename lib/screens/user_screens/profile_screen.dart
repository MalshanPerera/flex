import 'package:flex/bloc/home_screen_bloc.dart';
import 'package:flex/bloc/loading_bloc.dart';
import 'package:flex/bloc/profile_bloc.dart';
import 'package:flex/helper/app_assets.dart';
import 'package:flex/helper/app_colors.dart';
import 'package:flex/helper/app_utils.dart';
import 'package:flex/widgets/loading_barrier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  ProfileBloc _profileBloc;
  LoadingBloc _loadingBloc;

  bool _isLoaded = false;

  List<String> _ach = ["Complete 14 days Challenge", "Exercise for 5 days Straight", "Exercise for 10 days Straight"];
  List<String> _badges = ["Weight Lost Master", "No Pain No Gain", "Gainz for Dayz", "I am Iron Man"];

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
              body: Padding(
                padding: EdgeInsets.only(left: Utils.getDesignWidth(26), top: Utils.getDesignHeight(20.0), right: Utils.getDesignWidth(26)),
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
                                    "Level ${snapshot.data.level}",
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
                      padding: EdgeInsets.only(top: Utils.getDesignHeight(20.0),),
                      child: Text(
                        "Achievements",
                        style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    StreamBuilder(
                      stream: _profileBloc.userDetailsStream,
                      builder: (context, AsyncSnapshot<UserDetails> snapshot) {
                        return snapshot.hasData && snapshot.data.achievementsList.isNotEmpty ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: snapshot.data.achievementsList.map((a) {
                              return Text("$a");
                            }).toList(),
                          ),
                        ) :_noDataWidgets(text: "No Achievements");
                      }
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Utils.getDesignHeight(20.0),),
                      child: Text(
                        "Badges",
                        style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    StreamBuilder(
                      stream: _profileBloc.userDetailsStream,
                      builder: (context, AsyncSnapshot<UserDetails> snapshot) {
                        return snapshot.hasData && snapshot.data.badgesList.isNotEmpty? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: snapshot.data.badgesList.map((b) {
                              return Text("$b");
                            }).toList(),
                          ),
                        ) : _noDataWidgets(text: "No Badges");
                      }
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

  Widget _noDataWidgets({String text}){
    return Container(
      margin: EdgeInsets.only(top: Utils.getDesignHeight(10.0)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        height: Utils.getDesignHeight(100),
        width: double.infinity,
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
        )
    );
  }
}
