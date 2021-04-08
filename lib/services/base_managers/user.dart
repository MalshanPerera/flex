
abstract class UserManager {

  Future<bool> get isLoggedIn;

  Future<String> get getUserId;

  void saveUserId(String uid);
}