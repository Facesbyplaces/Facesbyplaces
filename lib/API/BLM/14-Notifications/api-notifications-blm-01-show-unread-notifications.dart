import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<int> apiBLMShowUnreadNotifications() async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/notifications/numOfUnread',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The notification status code in blm is ${response.statusCode}');
  print('The notification status body in blm is ${response.body}');

  if(response.statusCode == 200){
    var value = json.decode(response.body);
    print('The unread notifications is ${value['number_of_unread_notifs']}');
    return value['number_of_unread_notifs'];
  }else{
    return 0;
  }
}
