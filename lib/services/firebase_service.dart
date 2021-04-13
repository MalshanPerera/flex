import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  // --- sign in, up and out
  Future<String> signIn(String email, String password) async {

    UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password).onError((error, stackTrace) {
      SkeletonException exc =  GeneralException(
        error.toString().split("] ").last, ExceptionTypes.REQUEST_ERROR,
      );
      locator<ErrorService>().setError(exc);

      return null;
    });

    User user = result.user;

    print(user.uid);
    return user.uid;
  }

  Future<String> signUp(String email, String password, String name, String gender, String userType) async {

    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password).onError((error, stackTrace) {
      SkeletonException exc =  GeneralException(
        error.toString().split("] ").last, ExceptionTypes.REQUEST_ERROR,
      );
      locator<ErrorService>().setError(exc);

      return null;
    });

    User user = result.user;
    return user.uid;
  }

  Future<bool> setData({String userId, Map<String, dynamic> map}) async {
    await _firebaseFirestore.collection('user').doc(userId).set(map).onError((error, stackTrace) {
      SkeletonException exc =  GeneralException(
        error.toString(), ExceptionTypes.REQUEST_ERROR,
      );
      locator<ErrorService>().setError(exc);

      return false;
    });

    print("DATA HAS BEEN SAVED TO THE DATABASE");

    return true;
  }

  Future<DocumentSnapshot> getUserData({String userId}) async {

    DocumentSnapshot doc;

    doc = await _firebaseFirestore.collection('user').doc(userId).get().onError((error, stackTrace) {
      SkeletonException exc =  GeneralException(
        error.toString(), ExceptionTypes.REQUEST_ERROR,
      );
      locator<ErrorService>().setError(exc);

      return doc;
    });

    return doc;
  }

  Future<bool> setLeaderboardData({String uid, Map<String, dynamic> map}) async {
    await _firebaseFirestore.collection('leaderboard').doc(uid).set(map).onError((error, stackTrace) {
      SkeletonException exc =  GeneralException(
        error.toString(), ExceptionTypes.REQUEST_ERROR,
      );
      locator<ErrorService>().setError(exc);

      return;
    });

    print("DATA HAS BEEN SAVED TO THE LEADERBOARD");

    return true;
  }

  Future<bool> updateLeaderboardData({String uid, Map<String, dynamic> map}) async {
    await _firebaseFirestore.collection('leaderboard').doc(uid).update(map).onError((error, stackTrace) {
      SkeletonException exc =  GeneralException(
        error.toString(), ExceptionTypes.REQUEST_ERROR,
      );
      locator<ErrorService>().setError(exc);

      return;
    });

    print("DATA HAS BEEN UPDATED TO THE LEADERBOARD");

    return true;
  }

  Future<QuerySnapshot> getLeaderboardData() async {

    QuerySnapshot snapshot;

    snapshot = await _firebaseFirestore.collection('leaderboard').get().onError((error, stackTrace) {
      SkeletonException exc =  GeneralException(
        error.toString(), ExceptionTypes.REQUEST_ERROR,
      );
      locator<ErrorService>().setError(exc);

      return snapshot;
    });

    return snapshot;
  }

  Future<bool> setMotivationRate({String uid, Map<String, dynamic> map}) async {

    await _firebaseFirestore.collection('user').doc(uid).update(map).onError((error, stackTrace) {
      SkeletonException exc =  GeneralException(
        error.toString(), ExceptionTypes.REQUEST_ERROR,
      );
      locator<ErrorService>().setError(exc);

      return false;
    });

    return true;
  }

  Future<bool> setAchievement({String uid, Map<String, dynamic> map}) async {

    await _firebaseFirestore.collection('user').doc(uid).update(map).onError((error, stackTrace) {
      SkeletonException exc =  GeneralException(
        error.toString(), ExceptionTypes.REQUEST_ERROR,
      );
      locator<ErrorService>().setError(exc);

      return false;
    });

    return true;
  }

  Future<bool> setBadges({String uid, Map<String, dynamic> map}) async {

    await _firebaseFirestore.collection('user').doc(uid).update(map).onError((error, stackTrace) {
      SkeletonException exc =  GeneralException(
        error.toString(), ExceptionTypes.REQUEST_ERROR,
      );
      locator<ErrorService>().setError(exc);

      return false;
    });

    return true;
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