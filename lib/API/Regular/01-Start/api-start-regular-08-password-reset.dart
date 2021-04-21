import 'package:dio/dio.dart';

Future<bool> apiRegularPasswordReset({required String email, required String redirectLink}) async{

  Dio dioRequest = Dio();

  print('The redirect link is $redirectLink');

  var response = await dioRequest.post('http://fbp.dev1.koda.ws/alm_auth/password?email=$email&redirect_url=$redirectLink',
    options: Options(
      followRedirects: false,
      validateStatus: (status) {
        return status! < 600;
      },
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
      }
    ),  
  );

  print('The status code of regular password reset is ${response.statusCode}');
  print('The status message of regular password reset is ${response.data}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}