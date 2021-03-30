import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiRegularLogin({required String email, required String password, required String deviceToken}) async{

  bool result = false;

  try{
    Dio dioRequest = Dio();

    var response = await dioRequest.post('http://fbp.dev1.koda.ws/alm_auth/sign_in?account_type=2&password=$password&email=$email&device_token=$deviceToken',
      options: Options(
        headers: <String, dynamic>{
          'Content-Type': 'application/json',
        }
      ),  
    );

    print('The status code of login is ${response.statusCode}');

    print('The headers is ${response.headers['access-token']}');
    print('The uid is ${response.headers['uid']}');
    print('The client is ${response.headers['client']}');
    

    if(response.statusCode == 200){
      var newData = Map<String, dynamic>.from(response.data);

      var user = newData['user'];
      int userId = user['id'];

      final sharedPrefs = await SharedPreferences.getInstance();

      print('The new headers is ${response.headers['access-token'].toString().replaceAll(']', '').replaceAll('[', '')}');
      print('The new uid is ${response.headers['uid'].toString().replaceAll(']', '').replaceAll('[', '')}');
      print('The new client is ${response.headers['client'].toString().replaceAll(']', '').replaceAll('[', '')}');

      sharedPrefs.setInt('regular-user-id', userId);
      sharedPrefs.setString('regular-access-token', response.headers['access-token'].toString().replaceAll(']', '').replaceAll('[', ''));
      sharedPrefs.setString('regular-uid', response.headers['uid'].toString().replaceAll(']', '').replaceAll('[', ''));
      sharedPrefs.setString('regular-client', response.headers['client'].toString().replaceAll(']', '').replaceAll('[', ''));
      sharedPrefs.setBool('regular-user-session', true);
      sharedPrefs.setBool('user-guest-session', false);
      result = true;
    }
    return result;
  }catch(e){
    print('The error of login is: $e');
    return result;
  }
}