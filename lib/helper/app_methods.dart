class AppMethods {

  static Map<String, bool> getElements({String userType}){
    print(userType);

    if(userType == "Killer"){
      return {
        'achievements_badges': false,
        'leaderboard': true,
        'story': false,
        'level': true,
      };
    }
    if(userType == "Explorer"){
      return {
        'achievements_badges': true,
        'leaderboard': false,
        'story': true,
        'level': true,
      };
    }
    if(userType == "Achiever"){
      return {
        'achievements_badges': true,
        'leaderboard': true,
        'story': false,
        'level': true,
      };
    }
    if(userType == "Socializer"){
      return {
        'achievements_badges': true,
        'leaderboard': false,
        'story': true,
        'level': false,
      };
    }

    return {
      'achievements_badges': false,
      'leaderboard': false,
      'story': false,
      'level': false,
    };
  }

}