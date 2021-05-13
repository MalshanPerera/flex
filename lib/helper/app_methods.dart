class AppMethods {

  static Map<String, bool> getElements({String userType}){

    if(userType == "Killer"){
      return {
        'achievements_badges': false,
        'leaderboard': true,
        'story': false,
        'level': true,
        'points': true,
      };
    }
    if(userType == "Explorer"){
      return {
        'achievements_badges': true,
        'leaderboard': false,
        'story': true,
        'level': true,
        'points': false,
      };
    }
    if(userType == "Achiever"){
      return {
        'achievements_badges': true,
        'leaderboard': true,
        'story': false,
        'level': true,
        'points': true,
      };
    }
    if(userType == "Socializer"){
      return {
        'achievements_badges': true,
        'leaderboard': false,
        'story': true,
        'level': false,
        'points': false,
      };
    }

    return {
      'achievements_badges': false,
      'leaderboard': false,
      'story': false,
      'level': false,
      'points': false,
    };
  }
}