import 'package:dio/dio.dart';

Future<List<dynamic>> apiBLMPasswordReset({required String email, required String redirectLink}) async{
  Dio dioRequest = Dio();

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
    var newData = Map<String, dynamic>.from(response.data);
    bool status = newData['success'];
    String message = '';

    if(status){
      message = newData['message'];
    }else{
      message = newData['errors'];
    }

    return [status, message];
  }else{
    throw Exception('Something went wrong. Please try again.');
  }
}