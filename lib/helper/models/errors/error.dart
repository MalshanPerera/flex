import 'package:flex/services/base_managers/exceptions.dart';

class Error {
  final SkeletonException exception;
  final StackTrace stackTrace;

  Error(this.exception, this.stackTrace);
}