import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiRegularChangePassword({required String currentPassword, required String newPassword}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();
  // FormData formData = FormData();

  // formData.files.addAll([
  //   MapEntry('password', MultipartFile.fromString(currentPassword),),
  //   MapEntry('password_confirmation', MultipartFile.fromString(newPassword)),
  // ]);

  print('The access token is $getAccessToken');
  print('The uid is $getUID');
  print('The client is $getClient');

  // var response = await dioRequest.post('http://fbp.dev1.koda.ws/api/v1/users/changePassword', data: formData,
  // var response = await dioRequest.put('http://fbp.dev1.koda.ws/alm_auth/password?', data: formData,
  // 'http://fbp.dev1.koda.ws/auth/sign_in?account_type=1&password=$password&email=$email&device_token=$deviceToken'
  var response = await dioRequest.put('http://fbp.dev1.koda.ws/alm_auth/password?password=$currentPassword&password_confirmation=$newPassword',
    options: Options(
      followRedirects: false,
      validateStatus: (status) {
        return status! < 600;
      },
      headers: <String, dynamic>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  print('The status code of regular change password is ${response.statusCode}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}