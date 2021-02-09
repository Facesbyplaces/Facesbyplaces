import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> apiRegularLogin({String email, String password}) async{

  bool value = false;

  try{
    
    final http.Response response = await http.post('http://fbp.dev1.koda.ws/alm_auth/sign_in?account_type=2&password=$password&email=$email',
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
      sharedPrefs.setString('regular-access-token', response.headers['access-token']);
      sharedPrefs.setString('regular-uid', response.headers['uid']);    
      sharedPrefs.setString('regular-client', response.headers['client']);
      sharedPrefs.setBool('regular-user-session', true);

      return true;
    }
  }catch(e){
    throw Exception('Something went wrong. $e');
  }

  return value;
}