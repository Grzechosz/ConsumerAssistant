
import 'package:consciousconsumer/services/products_service.dart';
import 'package:consciousconsumer/services/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';

class AuthenticationService{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser _userFromFirebase(User user){
    return AppUser(id: user.uid, name: user.displayName??"null", email: user.email!);
  }

  Stream<AppUser> get user{
    return _auth.authStateChanges()
        .map((user) => user!=null ? _userFromFirebase(user) : AppUser.emptyUser);
  }

  Future signInAnonymous() async{
    try{
      UserCredential credential = await _auth.signInAnonymously();
      return credential.user;
    }catch(exception){
      return AppUser.emptyUser;
    }
  }

  Future logOut() async{
    return await _auth.signOut();
  }

  Future register(String email, String password) async {
    try{
      UserCredential userCredentials = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredentials.user;
      return _userFromFirebase(user!);
    }catch(e){
      return AppUser.emptyUser;
    }
  }

  Future logIn(String email, String password) async{
    try{
      UserCredential userCredentials = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredentials.user;
      return _userFromFirebase(user!);
    }catch(e){
      return AppUser.emptyUser;
    }
  }

  void updateName(String name){
    _auth.currentUser?.updateDisplayName(name);
  }

  void updateEmail(String newEmail){
    _auth.currentUser?.updateEmail(newEmail);
  }

  void deleteAccount(){
    ProductsService service = ProductsService(userId: _auth.currentUser?.uid);
    service.clearProducts(_auth.currentUser!.uid).then((value) => _auth.currentUser?.delete());
  }

  void updatePassword(String newPassword){
    _auth.currentUser?.updatePassword(newPassword);
  }
}