import 'package:consciousconsumer/screens/authentication/log_in.dart';
import 'package:consciousconsumer/services/products_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/app_user.dart';
import 'notifications_service.dart';

class AuthenticationService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<AppUser> get user {
    return _auth.authStateChanges().map((user) =>
        user != null ? AppUser.fromFirebase(user) : AppUser.emptyUser);
  }

  Future signInAnonymous() async {
    try {
      UserCredential credential = await _auth.signInAnonymously();
      return credential.user;
    } catch (exception) {
      return AppUser.emptyUser;
    }
  }

  Future logOut() async {
    return await _auth.signOut();
  }

  Future<AppUser> register(
      String email, String password, String nickname) async {
    try {
      UserCredential credentials = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = credentials.user!;
      firebaseUser
          .updateDisplayName(nickname)
          .then((value) => notifyListeners());
      firebaseUser.sendEmailVerification();
      NotificationsService(uid: firebaseUser.uid)
          .firebaseMessaging
          .subscribeToTopic("email_activation");
      return AppUser.fromFirebase(firebaseUser);
    } catch (e) {
      return AppUser.emptyUser;
    }
  }

  Future logIn(String email, String password) async {
    try {
      UserCredential userCredentials = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      AppUser appUser = AppUser.fromFirebase(userCredentials.user!);
      if (appUser.isEmailVerified) {
        NotificationsService(uid: appUser.id)
            .firebaseMessaging
            .unSubscribeTopic("email_activation");
      }
      return appUser;
    } catch (e) {
      print(e);
      return AppUser.emptyUser;
    }
  }

  Future reAuthorization(String email, String password) async {
    try {
      User user = FirebaseAuth.instance.currentUser!;
      UserCredential userCredential = await user!.reauthenticateWithCredential(
          EmailAuthProvider.credential(email: email, password: password));
      AppUser appUser = AppUser.fromFirebase(userCredential.user!);
      return appUser;
    } catch (e) {
      print(e);
      return AppUser.emptyUser;
    }
  }

  void updateName(String name) {
    _auth.currentUser!
        .updateDisplayName(name)
        .whenComplete(() => print('zakonczone zmienianie nicku'))
        .onError((error, stackTrace) => error)
        .then((value) => notifyListeners());
  }

  void updateEmail(String newEmail) {
    _auth.currentUser!.verifyBeforeUpdateEmail(newEmail);
    _auth.currentUser!
        .updateEmail(newEmail)
        .whenComplete(() => print('zakonczono zmiane emaila'))
        .onError((error, stackTrace) => error)
        .then((value) => notifyListeners());
  }

  void deleteAccount(BuildContext context) {
    ProductsService service = ProductsService(userId: _auth.currentUser?.uid);
    service.clearProducts(_auth.currentUser!.uid).then((value) => _auth
        .currentUser!
        .delete()
        .whenComplete(() => print('zakonczono usuwanie'))
        .onError((error, stackTrace) => error));
  }

  void updatePassword(String newPassword) {
    _auth.currentUser!
        .updatePassword(newPassword)
        .whenComplete(() => print('zakonczono zmienianie hasla'))
        .onError((error, stackTrace) => throw Exception(error));
  }

  void forgetPassword(String email) {
    _auth.sendPasswordResetEmail(email: email)
        .whenComplete(() => print('zapomniales haslo'))
        .onError((error, stackTrace) => throw Exception(error));
  }
}
