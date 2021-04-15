// // import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:async';

// final String serverToken = 'AAAAZak_Sp8:APA91bFUCfkKaLLzut34C_kectoUuxz1MChryr4QHEmvKgCFu9slX7GcKkeGMG8SjG1mDAkDNK7_ZJ8ri6S_uhxw8yL5rgxBfsfEDlE97g33ohejhhfP-xMXSYISXqZMOn_NTRp1J5Vv';
// // final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
// // final FirebaseMessaging firebaseMessaging = firebaseMessaging;

// Future<Map<String, dynamic>> sendAndRetrieveMessage() async {
//   // await firebaseMessaging.requestNotificationPermissions(
//   //   const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
//   // );
//   // await firebaseMessaging.requestPermission(sound: true, badge: true, alert: true, provisional: false);

//   final http.Response response = await http.post(
//     Uri.http('https://fcm.googleapis.com/fcm/send', ''),
//     headers: <String, String>{
//       'Content-Type': 'application/json',
//       'Authorization': 'key=$serverToken',
//     },
//     body: jsonEncode(
//       <String, dynamic>{
//         'notification': <String, dynamic>{
//           'body': 'New notification',
//           'title': 'FacesbyPlaces Notification'
//         },
//         'priority': 'high',
//         'data': <String, dynamic>{
//           'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//           'id': '1',
//           'status': 'done'
//         },
//         //  'to': await firebaseMessaging.getToken(),
//       },
//     ),
//   );

//   // String token = await firebaseMessaging.getToken();
//   // String token = (await firebaseMessaging.getToken())!;

//   // print('The token is $token');
//   print('The status code for push notifications is ${response.statusCode}');
//   print('The status body for push notifications is ${response.body}');

//   final Completer<Map<String, dynamic>> completer = Completer<Map<String, dynamic>>();

//   return completer.future;
// }