import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiRegularSignInWithGoogle({required String firstName, required String lastName, required String email, required String username, required String googleId, required String image}) async{
  Dio dioRequest = Dio();

  // var response = await dioRequest.post('https://facesbyplaces.com/alm_auth/sign_in?account_type=2&first_name=$firstName&last_name=$lastName&email=$email&username=$username&google_id=$googleId&image=$image',
  var response = await dioRequest.post('https://www.facesbyplaces.com/alm_auth/sign_in?account_type=2&first_name=$firstName&last_name=$lastName&email=$email&username=$username&google_id=$googleId&image=$image',
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

    sharedPrefs.setInt('regular-user-id', userId);
    sharedPrefs.setString('regular-access-token', response.headers['access-token'].toString().replaceAll(']', '').replaceAll('[', ''));
    sharedPrefs.setString('regular-uid', response.headers['uid'].toString().replaceAll(']', '').replaceAll('[', ''));
    sharedPrefs.setString('regular-client', response.headers['client'].toString().replaceAll(']', '').replaceAll('[', ''));
    sharedPrefs.setBool('regular-user-session', true);
    sharedPrefs.setBool('user-guest-session', false);

    return true;
  }else{
    throw Exception('Something went wrong. Please try again');
  }
}