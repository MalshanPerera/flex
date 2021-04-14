import 'package:flex/bloc/change_user_details_bloc.dart';
import 'package:flex/bloc/home_screen_bloc.dart';
import 'package:flex/bloc/loading_bloc.dart';
import 'package:flex/helper/app_colors.dart';
import 'package:flex/helper/app_strings.dart';
import 'package:flex/helper/app_utils.dart';
import 'package:flex/widgets/custom_textfield.dart';
import 'package:flex/widgets/loading_barrier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ChangeUserDetailsScreen extends StatefulWidget {
  @override
  _ChangeUserDetailsScreenState createState() => _ChangeUserDetailsScreenState();
}

class _ChangeUserDetailsScreenState extends State<ChangeUserDetailsScreen > {

  final GlobalKey<FormState> _key = GlobalKey();

  ChangeUserDetailsBloc _changeUserDetailsBloc;
  LoadingBloc _loadingBloc;

  String name, height, weight;
  int gender, userType;

  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(!_isLoaded){
      _changeUserDetailsBloc = Provider.of<ChangeUserDetailsBloc>(context);
      _changeUserDetailsBloc.getUserData();
      _loadingBloc = Provider.of<LoadingBloc>(context);
      _isLoaded = true;
    }
  }

  @override
  void dispose() {
    _key.currentState?.dispose();
    super.dispose();
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
                child: GestureDetector(
                  onTap: ()=> FocusScope.of(context).unfocus(),
                  child: Padding(
                    padding: EdgeInsets.only(left: Utils.getDesignWidth(26), right: Utils.getDesignWidth(26)),
                    child: StreamBuilder(
                      stream: _changeUserDetailsBloc.userDetailsStream,
                      builder: (context, AsyncSnapshot<UserDetails> oldSnapshot) {
                        return oldSnapshot.hasData ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: Utils.getDesignHeight(20)),
                              child: Center(
                                child: Text(
                                  "Edit Details",
                                  style: Theme.of(context).primaryTextTheme.headline1.copyWith(
                                    fontSize: 35.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: Utils.getDesignHeight(15)),
                              child: Form(
                                key: _key,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomTextField(
                                      initialValue: oldSnapshot.data.name,
                                      title: "Name",
                                      onChange: (name) => this.name = name,
                                      validator: (text){
                                        if(text.length == 0){
                                          return REQUIRED_FIELD;
                                        }
                                        return null;
                                      },
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: Utils.getDesignHeight(20)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: Utils.getDesignWidth(150),
                                            child: CustomTextField(
                                              initialValue: "${oldSnapshot.data.weight}",
                                              keyboardType: TextInputType.number,
                                              title: "Weight",
                                              onChange: (weight) => this.weight = weight,
                                              validator: (text){
                                                if(text.length == 0){
                                                  return REQUIRED_FIELD;
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          Container(
                                            width: Utils.getDesignWidth(150),
                                            child: CustomTextField(
                                              initialValue: "${oldSnapshot.data.height}",
                                              keyboardType: TextInputType.number,
                                              title: "Height",
                                              onChange: (height) => this.height = height,
                                              validator: (text){
                                                if(text.length == 0){
                                                  return REQUIRED_FIELD;
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: Utils.getDesignHeight(15)),
                                      child: Text(
                                        "User Type",
                                        style: Theme.of(context).primaryTextTheme.bodyText1,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                      child: Text(
                                        "Take the Bartle's Test before selecting a user type",
                                        style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                                          fontSize: 12.0,
                                          color: Colors.deepPurpleAccent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: PRIMARY_COLOR, width: 0.5),
                                ),
                                width: double.infinity,
                                child: Text(
                                  "User Type Test",
                                  style: Theme.of(context).primaryTextTheme.bodyText1,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              onTap: () => _launchURL(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: Utils.getDesignHeight(10)),
                              child: StreamBuilder(
                                  stream: _changeUserDetailsBloc.userTypeRadioBtnStream,
                                  initialData: _userTypeInt(oldSnapshot.data.userType),
                                  builder: (context, snapshot) {
                                    return Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: ListTile(
                                                contentPadding: EdgeInsets.all(0.0),
                                                leading: Radio(
                                                  value: 1,
                                                  groupValue: snapshot.data,
                                                  onChanged: (value) {
                                                    this.userType = value;
                                                    _changeUserDetailsBloc.userTypeRadioBtnSink.add(value);
                                                  },
                                                ),
                                                title: Text(
                                                  "Achievers",
                                                  style: Theme.of(context).primaryTextTheme.bodyText1,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: ListTile(
                                                leading: Radio(
                                                  value: 2,
                                                  groupValue: snapshot.data,
                                                  onChanged: (value) {
                                                    this.userType = value;
                                                    _changeUserDetailsBloc.userTypeRadioBtnSink.add(value);
                                                  },
                                                ),
                                                title: Text(
                                                  "Socializer",
                                                  style: Theme.of(context).primaryTextTheme.bodyText1,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: ListTile(
                                                contentPadding: EdgeInsets.all(0.0),
                                                leading: Radio(
                                                  value: 3,
                                                  groupValue: snapshot.data,
                                                  onChanged: (value) {
                                                    this.userType = value;
                                                    _changeUserDetailsBloc.userTypeRadioBtnSink.add(value);
                                                  },
                                                ),
                                                title: Text(
                                                  "Explorer",
                                                  style: Theme.of(context).primaryTextTheme.bodyText1,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: ListTile(
                                                leading: Radio(
                                                  value: 4,
                                                  groupValue: snapshot.data,
                                                  onChanged: (value) {
                                                    this.userType = value;
                                                    _changeUserDetailsBloc.userTypeRadioBtnSink.add(value);
                                                  },
                                                ),
                                                title: Text(
                                                  "Killer",
                                                  style: Theme.of(context).primaryTextTheme.bodyText1,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  }
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: Utils.getDesignHeight(20.0)),
                              width: double.infinity,
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
                                  primary: PRIMARY_COLOR,
                                  onPrimary: Colors.grey,
                                  elevation: 0.0,
                                ),
                                child: Text(
                                  "Edit",
                                  style: Theme.of(context).primaryTextTheme.button.copyWith(
                                      color: Colors.white
                                  ),
                                ),
                                onPressed: () {
                                  if(_key.currentState.validate()){
                                    print(_userType(userTypeId: _userTypeInt(oldSnapshot.data.userType)));
                                    print(_userType(userTypeId: this.userType));
                                    _key.currentState.save();
                                    FocusScope.of(context).unfocus();
                                    _changeUserDetailsBloc.changeUserDetails(
                                      name: this.name ?? "${oldSnapshot.data.name}",
                                      height: double.parse(this.height ?? "${oldSnapshot.data.height}"),
                                      weight: double.parse(this.weight ?? "${oldSnapshot.data.weight}"),
                                      userType: _userType(userTypeId: this.userType) == "Non" ? _userType(userTypeId: _userTypeInt(oldSnapshot.data.userType)) : _userType(userTypeId: this.userType),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ) : Container();
                      }
                    ),
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

  int _userTypeInt(String userType){

    int value = 0;

    if(userType.contains("Achiever")){
      value = 1;
    }
    if(userType.contains("Socializer")){
      value = 2;
    }
    if(userType.contains("Explorer")){
      value = 3;
    }
    if(userType.contains("Killer")){
      value = 4;
    }

    return value;
  }

  String _userType({int userTypeId}){

    if(userTypeId == 1){
      return "Achiever";
    }

    if(userTypeId == 2){
      return "Socializer";
    }

    if(userTypeId == 3){
      return "Explorer";
    }

    if(userTypeId == 4){
      return "Killer";
    }

    return "Non";
  }

  _launchURL() async {
    if (await canLaunch(BARTLE_TEST)) {
      await launch(BARTLE_TEST);
    } else {
      throw 'Could not launch $BARTLE_TEST';
    }
  }
}
