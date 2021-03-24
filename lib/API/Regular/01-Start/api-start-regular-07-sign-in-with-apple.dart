import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiRegularSignInWithApple({required String userIdentification, required String identityToken}) async{

  bool result = false;

  try{
    Dio dioRequest = Dio();

    var response = await dioRequest.post('http://fbp.dev1.koda.ws/alm_auth/sign_in?account_type=2&first_name=&last_name=&user_identification=$userIdentification&identity_token=$identityToken',
      options: Options(
        headers: <String, dynamic>{
          'Content-Type': 'application/json',
        }
      ),  
    );

    print('The status code of login with apple is ${response.statusCode}');

    if(response.statusCode == 200){
      var newData = Map<String, dynamic>.from(response.data);
      var user = newData['user'];
      int userId = user['id'];

      final sharedPrefs = await SharedPreferences.getInstance();

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
    print('The error of login with apple is: $e');
    return result;
  }
}