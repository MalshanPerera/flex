import 'package:flex/helper/app_enums.dart';

class AppData {

  //Singleton
  AppData._privateConstructor();
  static final AppData _instance = AppData._privateConstructor();
  static AppData get getInstance => _instance;

  UserTypes userTypes;
  bool achievementsBadges;
  bool leaderboard;
  bool story;
  bool level;
  bool points;

}