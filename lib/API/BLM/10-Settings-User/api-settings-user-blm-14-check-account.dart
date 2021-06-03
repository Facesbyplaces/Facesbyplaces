import 'package:dio/dio.dart';

Future<bool> apiBLMCheckAccount({required String email}) async{

  Dio dioRequest = Dio();

  var response = await dioRequest.post('http://fbp.dev1.koda.ws/api/v1/users/check_password?account_type=2&email=$email',
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

  print('The status code of blm check account is ${response.statusCode}');
  print('The status data of blm check account is ${response.data}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    bool passwordUpdated = newData['password_updated'];

    print('The value of passwordUpdated is $passwordUpdated');
    return passwordUpdated;
  }else{
    throw Exception('Something went wrong. Please try again.');
  }
}