import 'package:dio/dio.dart';

Future<bool> apiRegularPasswordReset({required String email, required String redirectLink}) async{

  // final http.Response response = await http.post(
  //   Uri.http('http://fbp.dev1.koda.ws/alm_auth/password?email=$email&redirect_url=$redirectLink', ''),
  //   headers: <String, String>{
  //     'Content-Type': 'application/json',
  //   }
  // );

  // if(response.statusCode == 200){
  //   return true;
  // }else{
  //   return false;
  // }



  // Dio dioRequest = Dio();

  // var response = await dioRequest.post('http://fbp.dev1.koda.ws/alm_auth/password?email=$email&redirect_url=$redirectLink',);

  // print('The response status code of password reset is ${response.statusCode}');

  // if(response.statusCode == 200){
  //   return true;
  // }else{
  //   return false;
  // }

  bool result = false;

  try{
    Dio dioRequest = Dio();

    var response = await dioRequest.post('http://fbp.dev1.koda.ws/alm_auth/password?email=$email&redirect_url=$redirectLink',
      options: Options(
        headers: <String, dynamic>{
          'Content-Type': 'application/json',
        }
      ),  
    );

    print('The status code of password reset is ${response.statusCode}');

    if(response.statusCode == 200){
      result = true;
    }
    return result;
  }catch(e){
    print('The error of password reset is: $e');
    return result;
  }
}