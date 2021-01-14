import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> apiBLMLogin({String email, String password}) async{

  bool value = false;

  try{
    final http.Response response = await http.post(
      // 'http://fbp.dev1.koda.ws/auth/sign_in?email=$email&password=$password&account_type=1',
      'http://fbp.dev1.koda.ws/blm_auth/sign_in?account_type=1&password=$password&email=$email',
      headers: <String, String>{
        'Content-Type': 'application/json',
      }
    );

    print('The response status of login is ${response.statusCode}');
    print('The response status of login is ${response.body}');

    if(response.statusCode == 200){
      var value = json.decode(response.body);
      var user = value['user'];
      int userId = user['id'];

      final sharedPrefs = await SharedPreferences.getInstance();

      sharedPrefs.setInt('blm-user-id', userId);
      sharedPrefs.setString('blm-access-token', response.headers['access-token']);
      sharedPrefs.setString('blm-uid', response.headers['uid']);    
      sharedPrefs.setString('blm-client', response.headers['client']);
      sharedPrefs.setBool('blm-user-session', true);

      return true;
    }
  }catch(e){
    throw Exception('Something went wrong. $e');
  } 

  return value;
}


// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// Future<bool> apiRegularLogin({String email, String password}) async{

//   bool value = false;

//   try{
    
//     final http.Response response = await http.post(
//       // 'http://fbp.dev1.koda.ws/auth/sign_in?email=$email&password=$password&account_type=2',
//       'http://fbp.dev1.koda.ws/alm_auth/sign_in?account_type=2&password=$password&email=$email',
//       headers: <String, String>{
//         'Content-Type': 'application/json',
//       }
//     );

//     print('The response code of login is ${response.statusCode}');
//     print('The response body of login is ${response.body}');

//     if(response.statusCode == 200){
//       var value = json.decode(response.body);
//       var user = value['user'];
//       int userId = user['id'];

//       final sharedPrefs = await SharedPreferences.getInstance();

//       print('The access token in login is ${response.headers['access-token']}');
//       print('The uid in login is ${response.headers['uid']}');
//       print('The client in login is ${response.headers['client']}');

//       sharedPrefs.setInt('regular-user-id', userId);
//       sharedPrefs.setString('regular-access-token', response.headers['access-token']);
//       sharedPrefs.setString('regular-uid', response.headers['uid']);    
//       sharedPrefs.setString('regular-client', response.headers['client']);
//       sharedPrefs.setBool('regular-user-session', true);

//       return true;
//     }
//   }catch(e){
//     throw Exception('Something went wrong. $e');
//   }

//   return value;
// }