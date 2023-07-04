import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_firebase_notifications/notification_services.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/notification_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();

    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        print('device token');
        print(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Notifications'),
      ),
      body: Center(
        child: TextButton(
            onPressed: () {
              // send notification from one device to another
              notificationServices.getDeviceToken().then((value) async {
                var data = {
                  'to': value.toString(),
                  'notification': {
                    'title': 'Asif',
                    'body': 'Subscribe to my channel',
                    // "sound": "jetsons_doorbell.mp3"
                  },
                  'android': {
                    'notification': {
                      'notification_count': 23,
                    },
                  },
                  'data': {'type': 'msj', 'id': 'Asif Taj'}
                };

                await http.post(
                    Uri.parse('https://fcm.googleapis.com/fcm/send'),
                    body: jsonEncode(data),
                    headers: {
                      'Content-Type': 'application/json; charset=UTF-8',
                      'Authorization':
                          'key=AAAAflROfgk:APA91bEngi29xkoXPJoz_xSHgWuiwuWEmD_dWV-JCmdVQI1KEdv7Ifvu_e8PSJ-j8_kQn-ZR10GzThrhyk20khGXozIrMLjxKF3Zt6o56ceCh8_AHvaTqlvLDvBFV9rfw3TqWHMfDirN'
                    }).then((value) {
                  if (kDebugMode) {
                    print(value.body.toString());
                  }
                }).onError((error, stackTrace) {
                  if (kDebugMode) {
                    print(error);
                  }
                });
              });
            },
            child: Text('Send Notifications')),
      ),
    );
  }
}
