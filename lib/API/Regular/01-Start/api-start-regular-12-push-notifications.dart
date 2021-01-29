// Replace with server token from firebase console settings.




import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

// import 'package:overlay_support/overlay_support.dart';

final String serverToken = 'AAAAZak_Sp8:APA91bFUCfkKaLLzut34C_kectoUuxz1MChryr4QHEmvKgCFu9slX7GcKkeGMG8SjG1mDAkDNK7_ZJ8ri6S_uhxw8yL5rgxBfsfEDlE97g33ohejhhfP-xMXSYISXqZMOn_NTRp1J5Vv';
final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

Future<Map<String, dynamic>> sendAndRetrieveMessage() async {
  await firebaseMessaging.requestNotificationPermissions(
    const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
  );

  await http.post(
    'https://fcm.googleapis.com/fcm/send',
     headers: <String, String>{
       'Content-Type': 'application/json',
       'Authorization': 'key=$serverToken',
     },
     body: jsonEncode(
     <String, dynamic>{
       'notification': <String, dynamic>{
        //  'body': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        // 'body': 'Sample body notification',
        'body': 'New notification',
         'title': 'FacesbyPlaces Notification'
       },
       'priority': 'high',
       'data': <String, dynamic>{
         'click_action': 'FLUTTER_NOTIFICATION_CLICK',
         'id': '1',
         'status': 'done'
       },
      //  'to': await firebaseMessaging.getToken(),
     },
    ),
  );

  final Completer<Map<String, dynamic>> completer =
     Completer<Map<String, dynamic>>();

  // firebaseMessaging.configure(
  //     onMessage: (Map<String, dynamic> message) async {
  //       print("onMessage: $message");
  //       showSimpleNotification(
  //         Container(child: Text(message['notification']['body'])),
  //         position: NotificationPosition.top,
  //       );
  //     },
  //     onLaunch: (Map<String, dynamic> message) async {
  //       print("onLaunch: $message");
  //       showSimpleNotification(
  //         Container(child: Text(message['notification']['body'])),
  //         position: NotificationPosition.top,
  //       );
  //     },
  //     onResume: (Map<String, dynamic> message) async {
  //       print("onResume: $message");
  //       showSimpleNotification(
  //         Container(child: Text(message['notification']['body'])),
  //         position: NotificationPosition.top,
  //       );
  //     },
  // );

  return completer.future;
}