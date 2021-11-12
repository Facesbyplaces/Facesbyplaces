import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiBLMSignInWithApple({required String userIdentification, required String identityToken}) async{
  Dio dioRequest = Dio();

  var response = await dioRequest.post('https://www.facesbyplaces.com/auth/sign_in?account_type=1&first_name=&last_name=&user_identification=$userIdentification&identity_token=$identityToken&image=',
    options: Options(
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
      },
      validateStatus: (status){
        return status! < 600;
      },
      followRedirects: false, 
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
}