import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> apiBLMSignInWithApple({String userIdentification, String identityToken}) async{

  final http.Response response = await http.post('http://fbp.dev1.koda.ws/auth/sign_in?account_type=1&first_name=&last_name=&user_identification=$userIdentification&identity_token=$identityToken&image=',
    headers: <String, String>{
      'Content-Type': 'application/json',
    }
  );

  print('The status code for sign in with apple in blm is ${response.statusCode}');
  // print('The status body for sign in with apple in blm is ${response.body}');
  // print('The status headers for sign in with apple in blm is ${response.headers}');

  if(response.statusCode == 200){
    var value = json.decode(response.body);
    var newValue = value['user'];
    int userId = newValue['id'];
    // int userId = value['user'];
    final sharedPrefs = await SharedPreferences.getInstance();

    print('The id is $userId');
    print('The access token is ${response.headers['access-token']}');
    print('The uid is ${response.headers['uid']}');
    print('The client is ${response.headers['client']}');

    sharedPrefs.setInt('blm-user-id', userId);
    sharedPrefs.setString('blm-access-token', response.headers['access-token']);
    sharedPrefs.setString('blm-uid', response.headers['uid']);    
    sharedPrefs.setString('blm-client', response.headers['client']);
    sharedPrefs.setBool('blm-user-verify', true);

    return true;
  }else{
    return false;
  }
}