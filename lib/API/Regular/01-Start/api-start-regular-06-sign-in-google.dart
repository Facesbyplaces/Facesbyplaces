import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> apiRegularSignInWithGoogle({String firstName, String lastName, String email, String username, String googleId, String image}) async{

  final http.Response response = await http.post(
    // 'http://fbp.dev1.koda.ws/auth/sign_in?account_type=2&first_name=$firstName&last_name=$lastName&email=$email&username=$username&google_id=$googleId&image=$image',
    'http://fbp.dev1.koda.ws/alm_auth/sign_in?account_type=2&first_name=$firstName&last_name=$lastName&email=$email&username=$username&google_id=$googleId&image=$image',
    headers: <String, String>{
      'Content-Type': 'application/json',
    }
  );

  print('The status code for sign in with google is ${response.statusCode}');
  // print('The status body for sign in with google is ${response.body}');
  // print('The status headers for sign in with google is ${response.headers}');

  if(response.statusCode == 200){
    var value = json.decode(response.body);
    int userId = value['id'];
    String verificationCode = value['verification_code'];
    final sharedPrefs = await SharedPreferences.getInstance();

    sharedPrefs.setInt('regular-user-id', userId);
    sharedPrefs.setString('regular-verification-code', verificationCode);
    sharedPrefs.setString('regular-access-token', response.headers['access-token']);
    sharedPrefs.setString('regular-uid', response.headers['uid']);    
    sharedPrefs.setString('regular-client', response.headers['client']);
    // sharedPrefs.setBool('regular-user-verify', true);

    return true;
  }else{
    return false;
  }
}