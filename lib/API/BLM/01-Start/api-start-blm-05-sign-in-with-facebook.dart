import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> apiBLMSignInWithFacebook({required String firstName, required String lastName, required String email, required String username, required String facebookId, required String image}) async{

  final http.Response response = await http.post(
    Uri.http('http://fbp.dev1.koda.ws/auth/sign_in?account_type=1&first_name=$firstName&last_name=$lastName&email=$email&username=$username&facebook_id=$facebookId&image=$image', ''),
    headers: <String, String>{
      'Content-Type': 'application/json',
    }
  );

  if(response.statusCode == 200){
    var value = json.decode(response.body);
    int userId = value['id'];
    final sharedPrefs = await SharedPreferences.getInstance();

    sharedPrefs.setInt('blm-user-id', userId);
    sharedPrefs.setString('blm-access-token', response.headers['access-token']!);
    sharedPrefs.setString('blm-uid', response.headers['uid']!);
    sharedPrefs.setString('blm-client', response.headers['client']!);
    sharedPrefs.setBool('blm-user-session', true);
    sharedPrefs.setBool('user-guest-session', false);

    return true;
  }else{
    return false;
  }
}