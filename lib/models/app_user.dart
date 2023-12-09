import 'package:firebase_auth/firebase_auth.dart';

class AppUser{
  static final emptyUser = AppUser(
    id: 'null',
    name: 'null',
    email: 'null',
    isEmailVerified: false,
    createdAccountDate: DateTime.now(),
  );

  final String id;
  final String name;
  final String email;
  final bool isEmailVerified;
  final DateTime createdAccountDate;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.isEmailVerified,
    required this.createdAccountDate,
  });

  factory AppUser.fromFirebase(User user){
    return AppUser(id: user.uid,
        name: user.displayName??'null',
        email: user.email!,
        isEmailVerified: user.emailVerified,
      createdAccountDate: user.metadata.creationTime ?? DateTime.now(),
    );
  }
}