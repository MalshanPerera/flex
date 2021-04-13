
abstract class UserManager {

  Future<bool> get isLoggedIn;

  Future<String> get getDate;

  Future<String> get getUserId;

  Future<int> get getAchievement;

  void saveUserId(String uid);

  void saveDate(String date);

  void setAchievement(int count);
}