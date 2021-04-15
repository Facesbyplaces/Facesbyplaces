// // import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// Future<bool> apiRegularNewNotifications({String deviceToken, String title, String body}) async{

//   // final sharedPrefs = await SharedPreferences.getInstance();
//   // String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
//   // String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
//   // String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

//   final sharedPrefs = await SharedPreferences.getInstance();
//   bool userSessionRegular = sharedPrefs.getBool('regular-user-session') ?? false;
//   bool userSessionBLM = sharedPrefs.getBool('blm-user-session') ?? false;
//   String getAccessToken;
//   String getUID;
//   String getClient;

//   if(userSessionRegular == true){
//     getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
//     getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
//     getClient = sharedPrefs.getString('regular-client') ?? 'empty';
//   }else if(userSessionBLM == true){
//     getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
//     getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
//     getClient = sharedPrefs.getString('blm-client') ?? 'empty';
//   }

//   final http.Response response = await http.post('http://fbp.dev1.koda.ws/api/v1/notifications/pushNotification',
//     headers: <String, String>{
//       // 'Content-Type': 'application/json',
//       'access-token': getAccessToken,
//       'uid': getUID,
//       'client': getClient,
//     },
//     body: <String, String>{
//       'device_tokens': '$deviceToken',
//       'title': '$title',
//       'body': '$body',
//     }
//   );

//   print('The new status code of notification is ${response.statusCode}');
//   print('The new status code of notification is ${response.body}');

//   if(response.statusCode == 200){
//     return true;
//   }else{
//     return false;
//   }
// }