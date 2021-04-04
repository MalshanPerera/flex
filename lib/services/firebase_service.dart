import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flex/helper/app_enums.dart';
import 'package:flex/helper/models/errors/exceptions.dart';
import 'package:flex/helper/models/network/initialize_models.dart';
import 'package:flex/service_locator.dart';
import 'package:flex/services/base_managers/exceptions.dart';
import 'package:flex/services/base_managers/network.dart';
import 'package:flex/services/error_service.dart';
import 'package:flutter/foundation.dart';

class FirebaseService extends ServiceManager{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // --- sign in, up and out
  Future<String> signIn(String email, String password) async {
    UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    User user = result.user;

    return user.uid;
  }

  Future<String> signUp(String email, String password, String name, String gender, String userType) async {
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password).onError((error, stackTrace) {
      SkeletonException exc =  GeneralException(
        error.toString(), ExceptionTypes.REQUEST_ERROR,
      );
      locator<ErrorService>().setError(exc);

      return null;
    });

    User user = result.user;

    var x  = _firebaseFirestore.collection('user').doc(user.uid).set({
      'name': name,
      'gender': gender,
      'userType': userType,
    });

    print(x);

    return user.uid;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  @override
  Future<T> onResult<T>(result) async {
    Map<String, dynamic> map = {
      "type": T,
      "response": result,
    };
    // Parse into model class using a new isolate
    T res = await compute(getModel, map);
    return res;
  }

}