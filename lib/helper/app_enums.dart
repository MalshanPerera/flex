enum UserTypes {
  ACHIEVER,
  SOCIALIZER,
  EXPLORER,
  KILLER,
}

enum ExceptionTypes {
  TIMEOUT_EXCEPTION,
  SOCKET_EXCEPTION,
  REQUEST_ERROR,
  AP_ERROR,
  UNIMPLEMENTED_EXCEPTION,
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
      default:
        return "";
    }
  }
}