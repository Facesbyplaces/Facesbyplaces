import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiBLMLogin({required String email, required String password, required String deviceToken}) async{

  try{
    Dio dioRequest = Dio();

    Response<dynamic> response = await dioRequest.post(
      'http://fbp.dev1.koda.ws/auth/sign_in?account_type=1&password=$password&email=$email&device_token=$deviceToken',
      options: Options(
        headers: <String, dynamic>{
          'Content-Type': 'application/json',
        }
      ),  
    );

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
  }catch(e){
    print('Error in login: $e');
    return false;
  }

  // Dio dioRequest = Dio();

  // Response<dynamic> response = await dioRequest.post('http://fbp.dev1.koda.ws/auth/sign_in?account_type=1&password=$password&email=$email&device_token=$deviceToken', 
  //   options: Options(
  //     headers: <String, dynamic>{
  //       'Content-Type': 'application/json',
  //     }
  //   ),  
  // );

  // print('The status code of login is ${response.statusCode}');
  // print('The status data of login is ${response.data}');

  // if(response.statusCode == 200){
  //   var newData = Map<String, dynamic>.from(response.data);

  //   var user = newData['user'];
  //   int userId = user['id'];

  //   final sharedPrefs = await SharedPreferences.getInstance();

  //   sharedPrefs.setInt('blm-user-id', userId);
  //   sharedPrefs.setString('blm-access-token', response.headers['access-token'].toString().replaceAll(']', '').replaceAll('[', ''));
  //   sharedPrefs.setString('blm-uid', response.headers['uid'].toString().replaceAll(']', '').replaceAll('[', ''));
  //   sharedPrefs.setString('blm-client', response.headers['client'].toString().replaceAll(']', '').replaceAll('[', ''));
  //   sharedPrefs.setBool('blm-user-session', true);
  //   sharedPrefs.setBool('user-guest-session', false);
    
  //   return true;
  // }else{
  //   return false;
  // }
}