import 'package:dio/dio.dart';

Future<bool> apiBLMPasswordReset({required String email, required String redirectLink}) async{

  Dio dioRequest = Dio();

  var response = await dioRequest.post('http://fbp.dev1.koda.ws/auth/password?email=$email&redirect_url=$redirectLink',);

  print('The response status code of password reset is ${response.statusCode}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}