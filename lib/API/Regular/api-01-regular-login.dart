import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> apiRegularLogin(String email, String password) async{

  final http.Response response = await http.post(
    'http://fbp.dev1.koda.ws/auth/sign_in?email=$email&password=$password',
    headers: <String, String>{
      'Content-Type': 'application/json',
    }
  );

  // print('The headers in regular is ${response.headers}');
  // print('The response in regular status is ${response.statusCode}');
  // print('The response in regular status is ${response.body}');

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