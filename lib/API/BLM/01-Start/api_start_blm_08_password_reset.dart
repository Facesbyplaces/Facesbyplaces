import 'package:dio/dio.dart';

Future<bool> apiBLMPasswordReset({required String email, required String redirectLink}) async{
  Dio dioRequest = Dio();

  // var response = await dioRequest.post('https://facesbyplaces.com/auth/password?email=$email&redirect_url=$redirectLink',
  var response = await dioRequest.post('https://www.facesbyplaces.com/auth/password?email=$email&redirect_url=$redirectLink',
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
    return true;
  }else{
    return false;
  }
}