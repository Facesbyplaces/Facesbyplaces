import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiBLMLogin({required String email, required String password, required String deviceToken}) async{

  Dio dioRequest = Dio();

  var response = await dioRequest.post('http://fbp.dev1.koda.ws/auth/sign_in?account_type=1&password=$password&email=$email&device_token=$deviceToken', 
    options: Options(
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
      }
    ),  
  );

  print('The status code of login is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);

    var user = newData['user'];
    int userId = user['id'];

    final sharedPrefs = await SharedPreferences.getInstance();

    sharedPrefs.setInt('blm-user-id', userId);
    sharedPrefs.setString('blm-access-token', response.headers['access-token'].toString().replaceAll(']', '').replaceAll('[', ''));
    sharedPrefs.setString('blm-uid', response.headers['uid'].toString().replaceAll(']', '').replaceAll('[', ''));
    sharedPrefs.setString('blm-client', response.headers['client'].toString().replaceAll(']', '').replaceAll('[', ''));
    sharedPrefs.setBool('blm-user-session', true);
    sharedPrefs.setBool('user-guest-session', false);
    
    return true;
  }else{
    return false;
  }
}