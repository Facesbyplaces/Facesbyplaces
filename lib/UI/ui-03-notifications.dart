// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'dart:io';

// import 'package:overlay_support/overlay_support.dart';

// class PushNotificationMessage {
//   final String title;
//   final String body;
//   PushNotificationMessage({
//     @required this.title,
//     @required this.body,
//   });
// }

// class PushNotificationService {
//   final FirebaseMessaging _fcm;

//   PushNotificationService(this._fcm);

//   Future initialise() async {
//     if (Platform.isIOS) {
//       _fcm.requestNotificationPermissions(IosNotificationSettings());
//     }

//     // If you want to test the push notification locally,
//     // you need to get the token and input to the Firebase console
//     // https://console.firebase.google.com/project/YOUR_PROJECT_ID/notification/compose
//     String token = await _fcm.getToken();
//     print("FirebaseMessaging token: $token");

//     _fcm.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         print("onMessage: $message");
//         // notification = PushNotificationMessage(
//         //   title: message['notification']['title'],
//         //   body: message['notification']['body'],
//         // );

//         showSimpleNotification(
//           Container(child: Text(message['notification']['body'])),
//           position: NotificationPosition.top,
//         );
//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         print("onLaunch: $message");
//         showSimpleNotification(
//           Container(child: Text(message['notification']['body'])),
//           position: NotificationPosition.top,
//         );
//       },
//       onResume: (Map<String, dynamic> message) async {
//         print("onResume: $message");
//         showSimpleNotification(
//           Container(child: Text(message['notification']['body'])),
//           position: NotificationPosition.top,
//         );
//       },
//     );
//   }
// }




// class UINotifications extends StatefulWidget {

//   @override
//   _UINotificationsState createState() => _UINotificationsState();
// }

// class _UINotificationsState extends State<UINotifications> {
//   static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//   final pushNotificationService = PushNotificationService(_firebaseMessaging);

//   void initState(){
//     super.initState();
//     pushNotificationService.initialise();
//     // pushNotificationService._fcm.
//     // String token = FirebaseInstanceId. getInstance(). getToken()
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     // return Container(
      
//     // );
//     return Scaffold(
//       backgroundColor: Colors.amber,
//       body: Container(),
//     );
//   }
// }