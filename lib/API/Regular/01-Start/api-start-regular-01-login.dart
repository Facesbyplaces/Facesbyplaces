import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> apiRegularLogin({required String email, required String password, required String deviceToken}) async{

  bool value = false;

  print('The email in api is $email');
  print('The password in api is $password');
  print('The deviceToken in api is $deviceToken');

  try{
    final http.Response response = await http.post(
      // 'http://fbp.dev1.koda.ws/alm_auth/sign_in?account_type=2&password=$password&email=$email&device_token=$deviceToken',
      // Uri.http('http://fbp.dev1.koda.ws/alm_auth/sign_in?account_type=2&password=$password&email=$email&device_token=$deviceToken', ''),
      // Uri.http('fbp.dev1.koda.ws', '/alm_auth/sign_in?account_type=2&password=$password&email=$email&device_token=$deviceToken'),
      Uri.http('fbp.dev1.koda.ws', '/alm_auth/sign_in', {'account_type' : '2', 'email': '$email', 'password' : '$password', 'device_token' : '$deviceToken'}),

      // sign_in?account_type=2&password=$password&email=$email&device_token=$deviceToken

      // Uri.http("example.org", "/path", { "q" : "dart" });
      headers: <String, String>{
        'Content-Type': 'application/json',
      }
    );

    print('The status code of login is ${response.statusCode}');
    print('The status code of login is ${response.body}');

    if(response.statusCode == 200){
      var value = json.decode(response.body);
      var user = value['user'];
      int userId = user['id'];

      final sharedPrefs = await SharedPreferences.getInstance();

      sharedPrefs.setInt('regular-user-id', userId);
      sharedPrefs.setString('regular-access-token', response.headers['access-token']!);
      sharedPrefs.setString('regular-uid', response.headers['uid']!);
      sharedPrefs.setString('regular-client', response.headers['client']!);
      sharedPrefs.setBool('regular-user-session', true);
      sharedPrefs.setBool('user-guest-session', false);

      return true;
    }
  }catch(e){
    throw Exception('Something went wrong. $e');
  }

  return value;
}