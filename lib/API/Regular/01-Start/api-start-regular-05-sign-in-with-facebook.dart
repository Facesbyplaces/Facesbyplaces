import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> apiRegularSignInWithFacebook({String firstName, String lastName, String email, String username, String facebookId, String image}) async{

  final http.Response response = await http.post('http://fbp.dev1.koda.ws/auth/sign_in?account_type=2&first_name=$firstName&last_name=$lastName&email=$email&username=$username&facebook_id=$facebookId&image=$image',
    headers: <String, String>{
      'Content-Type': 'application/json',
    }
  );

   print('The status code for sign in with facebook in alm is ${response.statusCode}');
  print('The status body for sign in with facebook in alm is ${response.body}');

  if(response.statusCode == 200){
    var value = json.decode(response.body);
    int userId = value['id'];
    final sharedPrefs = await SharedPreferences.getInstance();

    sharedPrefs.setInt('regular-user-id', userId);
    sharedPrefs.setString('regular-access-token', response.headers['access-token']);
    sharedPrefs.setString('regular-uid', response.headers['uid']);    
    sharedPrefs.setString('regular-client', response.headers['client']);
    sharedPrefs.setBool('regular-user-verify', true);

    return true;
  }else{
    return false;
  }
}