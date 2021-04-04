import 'dart:async';

import 'package:flex/services/base_managers/error.dart';
import 'package:flex/services/base_managers/exceptions.dart';

class ErrorService extends ErrorManager {

  final StreamController<SkeletonException> _streamController = StreamController<SkeletonException>();

  @override
  void dispose() => _streamController.close();

  @override
  Stream<SkeletonException> get getErrorText => _streamController.stream;

  void setError(SkeletonException error) => _streamController.add(error);

}