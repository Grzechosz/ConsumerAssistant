import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

enum NotificationType{
  emailConfirmation;
}

class NotificationsService{
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  CollectionReference tokensCollection = FirebaseFirestore.instance.collection('tokens');
  String uid;
  String? token;

  NotificationsService({required this.uid});

  Future initNotifications() async {
    await _firebaseMessaging.setAutoInitEnabled(true);
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );
    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      token = await getToken();
      print('token: ${token}');
    }
  }

  Future<String> getToken() async {
    DocumentSnapshot<Object?> map =
      await tokensCollection!.doc(uid).get();
    String? token;
    if(map.exists) {
      token = map['token'] as String;
    }
    token ??= await saveToken();
    return token;
  }

  Future<String> saveToken() async {
    final token = await _firebaseMessaging.getToken();
    tokensCollection!.doc(uid).set({
    'token': token!
    });
    return token;
  }
}