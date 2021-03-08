import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> apiBLMLogin({required String email, required String password, required String deviceToken}) async{

  bool value = false;

  try{
    final http.Response response = await http.post(
      Uri.http('http://fbp.dev1.koda.ws/auth/sign_in?account_type=1&password=$password&email=$email&device_token=$deviceToken', ''),
      headers: <String, String>{
        'Content-Type': 'application/json',
      }
    );

    if(response.statusCode == 200){
      var value = json.decode(response.body);
      var user = value['user'];
      int userId = user['id'];

      final sharedPrefs = await SharedPreferences.getInstance();

      sharedPrefs.setInt('blm-user-id', userId);
      sharedPrefs.setString('blm-access-token', response.headers['access-token']!);
      sharedPrefs.setString('blm-uid', response.headers['uid']!);
      sharedPrefs.setString('blm-client', response.headers['client']!);
      sharedPrefs.setBool('blm-user-session', true);
      sharedPrefs.setBool('user-guest-session', false);

      return true;
    }
  }catch(e){
    throw Exception('Something went wrong. $e');
  } 

  return value;
}