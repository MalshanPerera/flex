import 'package:event_bus/event_bus.dart';
import 'package:flex/services/error_service.dart';
import 'package:flex/services/firebase_service.dart';
import 'package:flex/services/navigation_service.dart';
import 'package:flex/services/network_service.dart';
import 'package:flex/services/user_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => NetworkService());
  locator.registerLazySingleton(() => ErrorService());
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => FirebaseService());
  locator.registerLazySingleton(() => EventBus());

}