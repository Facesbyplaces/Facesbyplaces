// ignore_for_file: file_names
import 'package:dio/dio.dart';

Future<bool> apiBLMPasswordReset({required String email, required String redirectLink}) async{
  Dio dioRequest = Dio();

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

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}