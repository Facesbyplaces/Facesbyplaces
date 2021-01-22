import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> apiBLMPasswordChange({String password, String passwordConfirmation, String resetToken}) async{

  final http.Response response = await http.put('http://fbp.dev1.koda.ws/auth/password?password=$password&password_confirmation=$passwordConfirmation&reset_password_token=$resetToken',
    headers: <String, String>{
      'Content-Type': 'application/json',
    }
  );

  print('The status code for password change is ${response.statusCode}');
  print('The status body for password change is ${response.body}');
  print('The status headers for password change is ${response.headers}');

  if(response.statusCode == 200){
    var value = json.decode(response.body);
    var user = value['data'];
    int userId = user['id'];

    final sharedPrefs = await SharedPreferences.getInstance();

    sharedPrefs.setInt('blm-user-id', userId);
    sharedPrefs.setString('blm-access-token', response.headers['access-token']);
    sharedPrefs.setString('blm-uid', response.headers['uid']);    
    sharedPrefs.setString('blm-client', response.headers['client']);
    sharedPrefs.setBool('blm-user-session', true);
    return true;
  }else{
    return false;
  }
}