import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

enum NotificationType {
  emailConfirmation;
}

class NotificationsService extends ChangeNotifier {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final _messageStreamController = BehaviorSubject<RemoteMessage>();
  final _tokensCollection = FirebaseFirestore.instance.collection('users_data');
  final String _uid;
  String? token;

  NotificationsService({required String uid}) : _uid = uid;

  get firebaseMessaging {
    return _firebaseMessaging;
  }

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

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
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
    _tokensCollection.doc(_uid).set({'token': token!});
    return token;
  }

  void initForegroundNotifications(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Handling a foreground message: ${message.messageId}');
        print('Message data: ${message.data}');
        print('Message notification: ${message.notification?.title}');
        print('Message notification: ${message.notification?.body}');
        _messageStreamController.sink.add(message);
      }
      _showForegroundNotifications(context, message);
    });
  }

  //email_activation

  void _showForegroundNotifications(
      BuildContext contextPath, RemoteMessage message) {
    String? notificationType = message.data['type'];
    if (notificationType == null) {
      _standardNotification(contextPath, message);
    } else if (notificationType == 'email_activation') {
      _emailActivationNotification(contextPath, message);
    }
  }

  void _emailActivationNotification(BuildContext context, RemoteMessage message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message.notification?.title! ?? ''),
            content: Text(message.notification?.body! ?? ''),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  notifyListeners();
                },
                child: const Text('Aktywuj email'),
              ),
            ],
          );
        });
  }

  void _standardNotification(BuildContext context, RemoteMessage message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message.notification?.title! ?? ''),
            content: Text(message.notification?.body! ?? ''),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),

            ],
          );
        });
  }
}
