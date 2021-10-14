import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiBLMSignInWithFacebook({required String firstName, required String lastName, required String email, required String username, required String facebookId, required String image}) async{
  Dio dioRequest = Dio();

  var response = await dioRequest.post('https://facesbyplaces.com/auth/sign_in?account_type=1&first_name=$firstName&last_name=$lastName&email=$email&username=$username&facebook_id=$facebookId&image=$image',
    options: Options(
      followRedirects: false,
      validateStatus: (status){
        return status! < 600;
      },
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
}