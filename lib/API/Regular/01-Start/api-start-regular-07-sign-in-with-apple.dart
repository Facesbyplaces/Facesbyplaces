import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> apiRegularSignInWithApple({String userIdentification, String identityToken}) async{

  final http.Response response = await http.post('http://fbp.dev1.koda.ws/alm_auth/sign_in?account_type=2&first_name=&last_name=&user_identification=$userIdentification&identity_token=$identityToken&image=',
    headers: <String, String>{
      'Content-Type': 'application/json',
    }
  );

  if(response.statusCode == 200){
    var value = json.decode(response.body);
    var newValue = value['user'];
    int userId = newValue['id'];
    final sharedPrefs = await SharedPreferences.getInstance();

    sharedPrefs.setInt('regular-user-id', userId);
    sharedPrefs.setString('regular-access-token', response.headers['access-token']);
    sharedPrefs.setString('regular-uid', response.headers['uid']);    
    sharedPrefs.setString('regular-client', response.headers['client']);
    sharedPrefs.setBool('regular-user-session', true);
    sharedPrefs.setBool('user-guest-session', false);

    return true;
  }else{
    return false;
  }
}