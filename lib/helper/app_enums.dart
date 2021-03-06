enum UserTypes {
  ACHIEVER,
  SOCIALIZER,
  EXPLORER,
  KILLER,
  NON,
}

enum VideoType{
  NETWORK,
  FILE,
}

enum WorkoutType{
  ARMS,
  ABS,
  FULL_BODY,
}

enum HomeTabs{
  HOME,
  LEADERBOARD,
  PROFILE,
}

enum HomeTabsTwo{
  HOME,
  PROFILE,
}

enum ExceptionTypes {
  TIMEOUT_EXCEPTION,
  SOCKET_EXCEPTION,
  REQUEST_ERROR,
  AP_ERROR,
  UNIMPLEMENTED_EXCEPTION,
  SUCCESS,
}

extension ExceptionExtension on ExceptionTypes {
  String get name {
    switch (this) {
      case ExceptionTypes.TIMEOUT_EXCEPTION:
        return 'Timeout Exception';
      case ExceptionTypes.SOCKET_EXCEPTION:
        return 'Socket Exception';
      case ExceptionTypes.REQUEST_ERROR:
        return 'Request Error';
      case ExceptionTypes.AP_ERROR:
        return 'WIFI Error';
      case ExceptionTypes.UNIMPLEMENTED_EXCEPTION:
        return 'Unimplemented Exception';
      case ExceptionTypes.SUCCESS:
        return 'SUCCESS';
      default:
        return "";
    }
  }
}