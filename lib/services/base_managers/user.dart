
abstract class UserManager {

  Future<bool> get isLoggedIn;

  Future<int> get getUserId;

  void saveUserId(String uid);
}