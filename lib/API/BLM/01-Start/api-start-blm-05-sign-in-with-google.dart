import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> apiBLMSignInWithGoogle({String firstName, String lastName, String email, String username, String googleId, String image}) async{

  final http.Response response = await http.post(
    'http://fbp.dev1.koda.ws/auth/sign_in?account_type=1&first_name=$firstName&last_name=$lastName&email=$email&username=$username&google_id=$googleId&image=$image',
    headers: <String, String>{
      'Content-Type': 'application/json',
    }
  );

  print('The response status in sign in with google is ${response.statusCode}');
  print('The response body in sign in with google is ${response.body}');

  if(response.statusCode == 200){
    var value = json.decode(response.body);
    print('The value is ${value['verification_code']}');

    // var user = value['data'];
    // int userId = user['id'];
    // String verificationCode = user['verification_code'];


    int userId = value['id'];
    String verificationCode = value['verification_code'];
    final sharedPrefs = await SharedPreferences.getInstance();

    sharedPrefs.setInt('blm-user-id', userId);
    sharedPrefs.setString('blm-verification-code', verificationCode);
    sharedPrefs.setString('blm-access-token', response.headers['access-token']);
    sharedPrefs.setString('blm-uid', response.headers['uid']);    
    sharedPrefs.setString('blm-client', response.headers['client']);
    sharedPrefs.setBool('blm-user-verify', true);

    return true;
  }else{
    return false;
  }
}