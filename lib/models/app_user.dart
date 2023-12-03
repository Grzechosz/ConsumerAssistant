import 'package:firebase_auth/firebase_auth.dart';

class AppUser{
  static final emptyUser = AppUser(id: 'null', name: 'null', email: 'null', isEmailVerified: false, createdAccountData: DateTime.now());

  final String id;
  final String name;
  final String email;
  final bool isEmailVerified;
  final DateTime createdAccountData;
  AppUser({required this.id, required this.name, required this.email, required this.isEmailVerified, required this.createdAccountData});

  factory AppUser.fromFirebase(User user){
    return AppUser(id: user.uid,
        name: user.displayName??'null',
        email: user.email!,
        isEmailVerified: user.emailVerified,
        createdAccountData: user.metadata.creationTime??DateTime.now());
  }
}