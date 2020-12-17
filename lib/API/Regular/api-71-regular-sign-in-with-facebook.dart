import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> apiRegularSignInWithFacebook({String firstName, String lastName, String email, String username, String facebookId}) async{

  final http.Response response = await http.post(
    'http://fbp.dev1.koda.ws/auth?account_type=2&first_name=$firstName&last_name=$lastName&phone_number=123123123&email=$email&username=$username&password=password&facebook_id=$facebookId',
    headers: <String, String>{
      'Content-Type': 'application/json',
    }
  );

  print('The response status in sign in with facebook is ${response.statusCode}');
  print('The response body in sign in with facebook is ${response.body}');

  if(response.statusCode == 200){
    var value = json.decode(response.body);
    // var user = value['data'];
    // int userId = user['id'];
    // String verificationCode = user['verification_code'];

    // final sharedPrefs = await SharedPreferences.getInstance();

    int userId = value['id'];
    String verificationCode = value['verification_code'];
    final sharedPrefs = await SharedPreferences.getInstance();

    sharedPrefs.setInt('regular-user-id', userId);
    sharedPrefs.setString('regular-verification-code', verificationCode);
    sharedPrefs.setString('regular-access-token', response.headers['access-token']);
    sharedPrefs.setString('regular-uid', response.headers['uid']);    
    sharedPrefs.setString('regular-client', response.headers['client']);
    sharedPrefs.setBool('regular-user-verify', true);

    return true;
  }else{
    return false;
  }
}