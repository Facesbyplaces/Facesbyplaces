import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> apiRegularPasswordChange({String password, String passwordConfirmation, String resetToken}) async{

  final http.Response response = await http.put(
    'http://fbp.dev1.koda.ws/alm_auth/password?password=$password&password_confirmation=$passwordConfirmation&reset_password_token=$resetToken',
    headers: <String, String>{
      'Content-Type': 'application/json',
    }
  );

  print('The status code of password change is ${response.statusCode}');
  print('The status body of password change is ${response.body}');
  print('The status headers of password change is ${response.headers}');

  if(response.statusCode == 200){
    var value = json.decode(response.body);
    var user = value['data'];
    int userId = user['id'];

    final sharedPrefs = await SharedPreferences.getInstance();

    sharedPrefs.setInt('regular-user-id', userId);
    sharedPrefs.setString('regular-access-token', response.headers['access-token']);
    sharedPrefs.setString('regular-uid', response.headers['uid']);    
    sharedPrefs.setString('regular-client', response.headers['client']);
    sharedPrefs.setBool('regular-user-session', true);

    return true;
  }else{
    return false;
  }
}