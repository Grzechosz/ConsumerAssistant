import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

enum NotificationType{
  emailConfirmation;
}

class NotificationsService{
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _messageStreamController = BehaviorSubject<RemoteMessage>();
  final _tokensCollection = FirebaseFirestore.instance.collection('tokens');
  final String _uid;
  String? token;

  NotificationsService({required String uid}) : _uid = uid;

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

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Handling a foreground message: ${message.messageId}');
        print('Message data: ${message.data}');
        print('Message notification: ${message.notification?.title}');
        print('Message notification: ${message.notification?.body}');
        _messageStreamController.sink.add(message);
      }
    });

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      token = await getToken();
      if (kDebugMode) {
        print('token: $token');
      }
    }
  }

  Future<String> getToken() async {
    String token = await saveToken();
    return token;
  }

  Future<String> saveToken() async {
    final token = await _firebaseMessaging.getToken();
    _tokensCollection!.doc(_uid).set({
    'token': token!
    });
    return token;
  }
}