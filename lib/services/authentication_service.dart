import 'package:consciousconsumer/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:consciousconsumer/models/models.dart';
import 'package:flutter/material.dart';

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
      return AppUser.emptyUser;
    }
  }

  Future reAuthorization(String email, String password) async {
    try {
      User user = FirebaseAuth.instance.currentUser!;
      UserCredential userCredential = await user.reauthenticateWithCredential(
          EmailAuthProvider.credential(email: email, password: password));
      AppUser appUser = AppUser.fromFirebase(userCredential.user!);
      return appUser;
    } catch (e) {
      return AppUser.emptyUser;
    }
  }

  void updateName(String name) {
    _auth.currentUser!
        .updateDisplayName(name)
        .onError((error, stackTrace) => throw Exception(error))
        .then((value) => notifyListeners());
  }

  void updateEmail(String newEmail) {
    bool logOut = true;
    _auth.currentUser!
        .verifyBeforeUpdateEmail(newEmail)
        .onError((error, stackTrace) {
      logOut = false;
      throw Exception(error);
    }).then((value) => notifyListeners());
    if (logOut) {
      this.logOut();
    }
  }

  void deleteAccount(BuildContext context) {
    ProductsService service = ProductsService(userId: _auth.currentUser?.uid);
    service.clearProducts(_auth.currentUser!.uid).then((value) => _auth
        .currentUser!
        .delete()
        .onError((error, stackTrace) => throw Exception(error)));
  }

  void updatePassword(String newPassword) {
    _auth.currentUser!
        .updatePassword(newPassword)
        .onError((error, stackTrace) => throw Exception(error));
  }

  void forgetPassword(String email) {
    _auth
        .sendPasswordResetEmail(email: email)
        .onError((error, stackTrace) => throw Exception(error));
  }
}
