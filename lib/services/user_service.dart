import 'package:flex/services/base_managers/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// User service is to get user defined values in a global context as a temp cache
class UserService extends UserManager{

  @override
  Future<int> get getUserId async {
    final instance = await SharedPreferences.getInstance();
    return instance.getInt('userId');
  }

  @override
  Future<bool> get isLoggedIn async {
    final instance = await SharedPreferences.getInstance();
    return instance.containsKey('userId');
  }

  @override
  void saveUserId(String userId) async {
    final instance = await SharedPreferences.getInstance();
    instance.setString('userId', userId);
  }
}