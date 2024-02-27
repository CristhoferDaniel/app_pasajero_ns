import 'dart:async';

import 'package:app_pasajero_ns/data/models/notification_taxi_request.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static StreamController<String> _messageStream =
      new StreamController.broadcast();
  static Stream get messagesStream => _messageStream.stream;

  static Future _onBackgroundHandler(RemoteMessage message) async {
    // print('onBackground Handler ${message.messageId}');
    _messageStream.add(message.notification?.title ?? 'No title');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    // print('onMessage Handler ${message.messageId}');
    _messageStream.add(message.notification?.title ?? 'No title');
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    // print('onMessageOpenApp Handler ${message.messageId}');
    _messageStream.add(message.notification?.title ?? 'No title');
  }

  static Future initializeApp() async {
    // Push Notifications
    //await

    // Linea necesaria para obtener el Token.
    token = await FirebaseMessaging.instance.getToken();
    // log('Token $token');

    // Handlers
    FirebaseMessaging.onBackgroundMessage(_onBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);

    // Local Notifications
  }

  // Lo definimos solo para el lint. No lo usaremos nunca
  static closeStreams() {
    _messageStream.close();
  }

  // ENDPOINTS TO SEND NOTIFICATION
  static final DioClient _dioClient =
      DioClient('https://fcm.googleapis.com', Dio());
  static Future<void> sendTaxiRequest(
    String to,
    NotificationTaxiRequest data,
    String title,
    String body,
  ) async {
    final headers = {
      'Content-Type': 'application/json',
      // TODO: PROTEGER EL SERVER API KEY
      'Authorization':
          'key=AAAAbBjad50:APA91bF9lUMQIHUz_EIM2Srlmv2seS6Vm4YCc3I1cv_6LgAUL0of1qGDV3V9phrQxNZJFPIfn6oP9qIT7FchvH3VrwYoka07QAVZXBcPbKVt0sO-r5jXDS6ZfYUsIX4OuwEzprwl7n6L'
    };
    final dioBody = {
      'notification': {
        'body': body,
        'title': title,
        "android_channel_id": NCH_ID_DRIVERREQUEST
      },
      'priority': 'high',
      'ttl': '4500s',
      'data': data,
      'to': to
    };
    await _dioClient.post(
      '/fcm/send',
      data: dioBody,
      options: Options(headers: headers),
    );
  }
}

const String NCH_ID_DRIVERREQUEST = 'NCH_ID_DRIVERREQUEST';
