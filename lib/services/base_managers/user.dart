
abstract class UserManager {

  Future<bool> get isLoggedIn;

  Future<String> get getDate;

  Future<String> get getRateDate;

  Future<String> get getUserId;

  Future<int> get getAchievement;

  void saveUserId(String uid);

  void saveDate(String date);

  void saveRateDate(String rateDate);

  void setAchievement(int count);

  void clear();
}