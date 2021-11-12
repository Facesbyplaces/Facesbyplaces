import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<String> apiRegularLogin({required String email, required String password, required String deviceToken}) async{
  Dio dioRequest = Dio();

  var response = await dioRequest.post('https://www.facesbyplaces.com/alm_auth/sign_in?account_type=2&password=$password&email=$email&device_token=$deviceToken',
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

  print('The status code of login is ${response.statusCode}');
  print('The status data of login is ${response.data}');

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

    return 'Success'; 
  }else{
    var newData = Map<String, dynamic>.from(response.data);
    return newData['message'];
  }
}