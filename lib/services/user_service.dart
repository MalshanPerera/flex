import 'package:flex/services/base_managers/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// User service is to get user defined values in a global context as a temp cache
class UserService extends UserManager{

  @override
  Future<String> get getUserId async {
    final instance = await SharedPreferences.getInstance();
    return instance.getString('userId');
  }

  @override
  Future<String> get getDate async {
    final instance = await SharedPreferences.getInstance();
    return instance.getString('date');
  }

  @override
  Future<bool> get isLoggedIn async {
    final instance = await SharedPreferences.getInstance();
    return instance.containsKey('userId');
  }

  @override
  Future<int> get getAchievement async {
    final instance = await SharedPreferences.getInstance();
    return instance.getInt('AchievementDayCount');
  }

  @override
  void saveUserId(String userId) async {
    final instance = await SharedPreferences.getInstance();
    instance.setString('userId', userId);
  }

  @override
  void saveDate(String date) async {
    final instance = await SharedPreferences.getInstance();
    instance.setString('date', date);
  }

  @override
  void setAchievement(int count) async {
    final instance = await SharedPreferences.getInstance();
    instance.setInt('AchievementDayCount', count);
  }
}