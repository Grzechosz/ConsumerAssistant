import 'package:consciousconsumer/services/products_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';
import 'notifications_service.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<AppUser> get user {
    return _auth.authStateChanges().map((user) => user != null
        ? AppUser.fromFirebase(user)
        : AppUser.emptyUser);
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

  Future<AppUser> register(String email, String password, String nickname) async {
    try {
      UserCredential credentials = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = credentials.user!;
      firebaseUser.updateDisplayName(nickname);
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
      if(appUser.isEmailVerified) {
        NotificationsService(uid: appUser.id)
          .firebaseMessaging
          .unSubscribeTopic("email_activation");
      }
      return appUser;
    } catch (e) {
      return AppUser.emptyUser;
    }
  }

  void updateName(String name) {
    _auth.currentUser?.updateDisplayName(name);
  }

  void updateEmail(String newEmail) {
    _auth.currentUser?.updateEmail(newEmail);
  }

  void deleteAccount() {
    ProductsService service = ProductsService(userId: _auth.currentUser?.uid);
    service
        .clearProducts(_auth.currentUser!.uid)
        .then((value) => _auth.currentUser?.delete());
  }

  void updatePassword(String newPassword) {
    _auth.currentUser?.updatePassword(newPassword);
  }
}
