import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> apiBLMLogin(String email, String password) async{

  final http.Response response = await http.post(
    'http://fbp.dev1.koda.ws/auth/sign_in?email=$email&password=$password',
    headers: <String, String>{
      'Content-Type': 'application/json',
    }
  );

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