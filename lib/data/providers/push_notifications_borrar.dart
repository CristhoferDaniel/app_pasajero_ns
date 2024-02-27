import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class PushNotificationsProvider222 {
  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  StreamController<Map<String, dynamic>> _streamController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get message => _streamController.stream;

  String token = '';

  void initPushNotifications() async {
    String? t = await FirebaseMessaging.instance.getToken();
    if (t != null) {
      print('TokenFCM: $t');
    }

    // ON LAUNCH
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {
      if (message != null) {
        print('initial Message');
      }
    });

    // ON MESSAGE
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('OnMessage $message');
      Map<String, dynamic> data = message.data;
      _streamController.sink.add(data);
    });

    // ON RESUME
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('OnResume $message');
      Map<String, dynamic> data = message.data;
      _streamController.sink.add(data);
    });
  }

  Future<void> sendMessage(
      String to, Map<String, dynamic> data, String title, String body) async {
    Uri uri = Uri.https('fcm.googleapis.com', 'fcm/send');
    await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAbBjad50:APA91bF9lUMQIHUz_EIM2Srlmv2seS6Vm4YCc3I1cv_6LgAUL0of1qGDV3V9phrQxNZJFPIfn6oP9qIT7FchvH3VrwYoka07QAVZXBcPbKVt0sO-r5jXDS6ZfYUsIX4OuwEzprwl7n6L'
        },
        body: jsonEncode(<String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
          },
          'priority': 'high',
          'ttl': '4500s',
          'data': data,
          'to': to
        }));
  }

  void dispose() {
    _streamController.close();
  }
}
