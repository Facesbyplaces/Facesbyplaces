// import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
// import 'dart:convert';

Future<bool> apiHomeResetPassword({String email}) async{

  final http.Response response = await http.post(
    // 'http://fbp.dev1.koda.ws/auth/sign_in?email=$email&password=$password&account_type=1',
    'http://fbp.dev1.koda.ws/auth/password?email=$email&redirect_url=https://29cft.test-app.link/suCwfzCi6bb',
    headers: <String, String>{
      'Content-Type': 'application/json',
    }
  );

  print('The status code on password reset is ${response.statusCode}');
  print('The status body on password resetis ${response.body}');

  if(response.statusCode == 200){
    // var value = json.decode(response.body);
    // var user = value['user'];
    // int userId = user['id'];
    // print('The userId is $userId');

    // final sharedPrefs = await SharedPreferences.getInstance();

    // sharedPrefs.setInt('blm-user-id', userId);
    // sharedPrefs.setString('blm-access-token', response.headers['access-token']);
    // sharedPrefs.setString('blm-uid', response.headers['uid']);    
    // sharedPrefs.setString('blm-client', response.headers['client']);
    // sharedPrefs.setBool('blm-user-session', true);

    return true;
  }else{
    return false;
  }
}