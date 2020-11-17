import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> apiRegularLogin(String email, String password) async{

  final http.Response response = await http.post(
    'http://fbp.dev1.koda.ws/auth/sign_in?email=$email&password=$password',
    headers: <String, String>{
      'Content-Type': 'application/json',
    }
  );

  print('The headers is ${response.headers}');
  print('The response status is ${response.statusCode}');
  print('The response status is ${response.body}');

  if(response.statusCode == 200){

      final sharedPrefs = await SharedPreferences.getInstance();
      sharedPrefs.setString('regular-access-token', response.headers['access-token']);
      sharedPrefs.setString('regular-uid', response.headers['uid']);    
      sharedPrefs.setString('regular-client', response.headers['client']);
      sharedPrefs.setBool('regular-session', true);
    return true;
  }else{
    return false;
  }
}