
abstract class UserManager {

  Future<bool> get isLoggedIn;

  Future<String> get getDate;

  Future<String> get getUserId;

  void saveUserId(String uid);

  void saveDate(String date);
}