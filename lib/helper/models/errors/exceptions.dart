import 'package:firebase_auth/firebase_auth.dart';
import 'package:flex/helper/app_enums.dart';
import 'package:flex/services/base_managers/exceptions.dart';

class GeneralException implements SkeletonException {

  GeneralException(this.message, this.type);

  @override
  String message;

  @override
  ExceptionTypes type;

  @override
  String toString() => this.message;

  FirebaseAuthException firebaseAuthException;
}