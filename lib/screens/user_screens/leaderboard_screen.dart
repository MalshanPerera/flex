import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flex/bloc/leaderboard_bloc.dart';
import 'package:flex/bloc/loading_bloc.dart';
import 'package:flex/helper/app_assets.dart';
import 'package:flex/helper/app_colors.dart';
import 'package:flex/helper/app_utils.dart';
import 'package:flex/widgets/loading_barrier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LeaderBoardScreen extends StatefulWidget {
  @override
  _LeaderBoardScreenState createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {

  LeaderboardBloc _leaderboardBloc;
  LoadingBloc _loadingBloc;

  String _uuid;

  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(!_isLoaded){
      _uuid = FirebaseAuth.instance.currentUser.uid;

      _leaderboardBloc = Provider.of<LeaderboardBloc>(context);
      _loadingBloc = Provider.of<LoadingBloc>(context);

      _leaderboardBloc.getLeaderboardData();

      _isLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: PRIMARY_COLOR,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: BACKGROUND_COLOR,
              body: Column(
                children: [
                  _leaderboardHeader(),
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('leaderboard').orderBy('points', descending: true).snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        return snapshot.hasData ? ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (BuildContext context, index){
                            return Padding(
                              padding: EdgeInsets.only(top: 10.0, left: Utils.getDesignWidth(24), right: Utils.getDesignWidth(24)),
                              child: _leaderboardTile(
                                name: "${snapshot.data.docs[index]['name']}",
                                points: "${snapshot.data.docs[index]['points']} pts",
                                index: index,
                              ),
                            );
                          },
                        ) : Container();
                      }
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        LoadingBarrier(_loadingBloc.isLoading),
      ],
    );
  }

  Widget _leaderboardHeader(){
    return Container(
      color:PRIMARY_COLOR,
      height: Utils.getDesignHeight(220),
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: Utils.getDesignHeight(20.0)),
            child: Text(
              "Leaderboard",
              style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: Utils.getDesignHeight(30.0)),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('leaderboard').orderBy('points', descending: true).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                return snapshot.hasData ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        snapshot.hasData ? Text(
                          "${snapshot.data.docs.indexWhere((element) => element.data()['uid'] == _uuid) + 1}",
                          style: Theme.of(context).primaryTextTheme.headline1.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                          ),
                        ) : Container(),
                        Text(
                          " ${_placeString(snapshot.data.docs.indexWhere((element) => element.data()['uid'] == _uuid) + 1)}",
                          style: Theme.of(context).primaryTextTheme.headline1.copyWith(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 50.0,
                      backgroundImage:
                      NetworkImage(DEFAULT_AVATAR),
                      backgroundColor: Colors.white,
                    ),
                    Row(
                      children: [
                        Text(
                          "${snapshot.data.docs.where((element) => element.data()['uid'] == _uuid).last.data()['points']}",
                          style: Theme.of(context).primaryTextTheme.headline1.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                          ),
                        ),
                        Text(
                          " pts",
                          style: Theme.of(context).primaryTextTheme.headline1.copyWith(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ) : Container();
              }
            ),
          ),
        ],
      ),
    );
  }

  String _placeString(int index){

    String placeString = "th";

    if(index == 1){
      placeString = "st";
    }
    if(index == 2){
      placeString = "nd";
    }
    if(index == 3){
      placeString = "rd";
    }

    return placeString;
  }

  Widget _leaderboardTile({String name, String points, int index}){
    return ListTile(
      contentPadding: EdgeInsets.only(
        left: Utils.getDesignWidth(30.0),
        right: Utils.getDesignWidth(30.0),
        top: Utils.getDesignHeight(5.0),
        bottom: Utils.getDesignHeight(5.0),
      ),
      tileColor: Colors.white,
      leading: _place(index),
      title: Text(
        name,
        style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 15.0,
        ),
      ),
      trailing: Text(
        points,
        style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 18.0,
        ),
      ),
    );
  }

  Widget _place(int index){

    if(index == 0){
      return SvgPicture.asset(
        GOLD,
        height: Utils.getDesignHeight(25),
        width: Utils.getDesignWidth(25),
      );
    }

    if(index == 1){
      return SvgPicture.asset(
        SILVER,
        height: Utils.getDesignHeight(25),
        width: Utils.getDesignWidth(25),
      );
    }

    if(index == 2){
      return SvgPicture.asset(
        BROWNS,
        height: Utils.getDesignHeight(25),
        width: Utils.getDesignWidth(25),
      );
    }

    return Text(
      "${index + 1}",
      style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: 15.0,
      ),
    );
  }
}
