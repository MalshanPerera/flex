import 'package:flex/helper/models/errors/error.dart';
import 'package:flex/service_locator.dart';
import 'package:flex/services/error_service.dart';

abstract class ServiceManager {

  Future<T> onResult<T>(result);

  void onError(Error error){
    //Display error in UI
    locator<ErrorService>().setError(error.exception);
    //Report error to sentry
  }

}