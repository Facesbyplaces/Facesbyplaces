// import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
// import 'dart:convert';

Future<bool> apiBLMLogin(String email, String password) async{

  final http.Response response = await http.post(
    'https://testapi-fbp.free.beeceptor.com/login',
    headers: <String, String>{
      'Content-Type': 'application/json',
    }
  );

  print('The response status is ${response.statusCode}');
  print('The response status is ${response.body}');

  if(response.statusCode == 200){
      // var value = json.decode(response.body);
      // var user = value['user'];
      // var userId = user['id'];
      // var userEmail = user['email'];

      // final sharedPrefs = await SharedPreferences.getInstance();

      // sharedPrefs.setInt('blm-user-id', userId);
      // sharedPrefs.setString('blm-user-email', userEmail);
      // sharedPrefs.setString('blm-access-token', response.headers['access-token']);
      // sharedPrefs.setString('blm-uid', response.headers['uid']);    
      // sharedPrefs.setString('blm-client', response.headers['client']);
      // sharedPrefs.setBool('blm-session', true);
    return true;
  }else{
    return false;
  }
}