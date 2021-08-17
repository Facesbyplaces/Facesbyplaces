import 'package:dio/dio.dart';

Future<bool> apiRegularMemorialPaypalConnect({required String userId, required String name, required String email, required int memorialId}) async{
  Dio dioRequest = Dio();

  var response = await dioRequest.post('http://45.33.66.25:3001/api/v1/payments/braintree?paypal_user_id=$userId&paypalable_id=$memorialId&paypalable_type=Memorial&name=$name&email=$email',
    options: Options(
      followRedirects: false,
      validateStatus: (status){
        return status! < 600;
      },
    ),
  );

  print('The status code of regular paypal connect is ${response.statusCode}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}