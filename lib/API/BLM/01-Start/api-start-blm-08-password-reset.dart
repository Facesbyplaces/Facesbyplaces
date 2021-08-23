import 'package:dio/dio.dart';

Future<bool> apiBLMPasswordReset({required String email, required String redirectLink}) async{
  Dio dioRequest = Dio();

  // var response = await dioRequest.post('http://45.33.66.25:3001/auth/password?email=$email&redirect_url=$redirectLink',
  var response = await dioRequest.post('http://facesbyplaces.com/auth/password?email=$email&redirect_url=$redirectLink',
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

  print('The status code of blm password reset is ${response.statusCode}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}