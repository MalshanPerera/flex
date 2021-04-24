import 'package:flex/bloc/authentication_bloc.dart';
import 'package:flex/bloc/loading_bloc.dart';
import 'package:flex/helper/app_colors.dart';
import 'package:flex/helper/app_strings.dart';
import 'package:flex/helper/app_utils.dart';
import 'package:flex/helper/validation.dart';
import 'package:flex/screens/splash_screen.dart';
import 'package:flex/widgets/custom_textfield.dart';
import 'package:flex/widgets/loading_barrier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class UserLoginScreen extends StatefulWidget {
  @override
  _UserLoginScreenState createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final GlobalKey<FormState> _key = GlobalKey();

  AuthenticationBloc _authenticationBloc;
  LoadingBloc _loadingBloc;

  String email, password;

  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation("Asia/Colombo"));

    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    var initSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification: onSelectNotification);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(!_isLoaded){
      _authenticationBloc = Provider.of<AuthenticationBloc>(context);
      _loadingBloc = Provider.of<LoadingBloc>(context);
      _isLoaded = true;
    }
  }

  @override
  void dispose() {
    _key.currentState?.dispose();
    super.dispose();
  }

  Future<void> onSelectNotification(String payload) {
    return Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return SplashScreen();
    }));
  }

  Future<void> scheduleNotification() async {
    DateTime.now().add(Duration(seconds: 5));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel id',
      'channel name',
      'channel description',
      icon: '@mipmap/ic_launcher',
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Flex',
      'Time for your today\'s work out',
      tz.TZDateTime.now(tz.local).add(const Duration(days: 1,)),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: BACKGROUND_COLOR,
          child: SafeArea(
            child: Scaffold(
              body: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: Utils.getDesignHeight(20)),
                    child: Center(
                      child: Text(
                        "Login",
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
                      child: Padding(
                        padding: EdgeInsets.only(left: Utils.getDesignWidth(26), right: Utils.getDesignWidth(26)),
                        child: Column(
                          children: [
                            CustomTextField(
                              title: "Email",
                              onChange: (email) => this.email = email,
                              validator: (text){
                                if(text.length == 0){
                                  return REQUIRED_FIELD;
                                }
                                if(!Validation.isValidEmail(text)){
                                  return WRONG_EMAIL;
                                }
                                return null;
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: Utils.getDesignHeight(15)),
                              child: CustomTextField(
                                title: "Password",
                                obscureText: true,
                                onChange: (pwd) => this.password = pwd,
                                validator: (text){
                                  if(text.length == 0){
                                    return REQUIRED_FIELD;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: Utils.getDesignHeight(50.0)),
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
                                  "Login",
                                  style: Theme.of(context).primaryTextTheme.button.copyWith(
                                      color: Colors.white
                                  ),
                                ),
                                onPressed: () {
                                  if(_key.currentState.validate()){
                                    _key.currentState.save();
                                    FocusScope.of(context).unfocus();
                                    _authenticationBloc.login(
                                      email: this.email,
                                      password: this.password,
                                    ).then((value) {
                                      if(value){
                                        scheduleNotification();
                                      }
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
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
}
