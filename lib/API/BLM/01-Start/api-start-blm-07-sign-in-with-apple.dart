import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> apiBLMSignInWithApple({String userIdentification, String identityToken}) async{

  final http.Response response = await http.post('http://fbp.dev1.koda.ws/auth/sign_in?account_type=1&first_name=&last_name=&user_identification=$userIdentification&identity_token=$identityToken&image=',
    headers: <String, String>{
      'Content-Type': 'application/json',
    }
  );

  if(response.statusCode == 200){
    var value = json.decode(response.body);
    var newValue = value['user'];
    int userId = newValue['id'];
    final sharedPrefs = await SharedPreferences.getInstance();

    sharedPrefs.setInt('blm-user-id', userId);
    sharedPrefs.setString('blm-access-token', response.headers['access-token']);
    sharedPrefs.setString('blm-uid', response.headers['uid']);    
    sharedPrefs.setString('blm-client', response.headers['client']);
    sharedPrefs.setBool('blm-user-session', true);
    sharedPrefs.setBool('user-guest-session', false);

    return true;
  }else{
    return false;
  }
}