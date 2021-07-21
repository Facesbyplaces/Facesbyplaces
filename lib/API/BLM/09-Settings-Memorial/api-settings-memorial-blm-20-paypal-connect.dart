import 'package:dio/dio.dart';

Future<bool> apiBLMMemorialPaypalConnect({required String userId, required String name, required String email, required int memorialId}) async{
  Dio dioRequest = Dio();

  var response = await dioRequest.post('http://fbp.dev1.koda.ws/api/v1/payments/braintree?paypal_user_id=$userId&paypalable_id=$memorialId&paypalable_type=Blm&name=$name&email=$email',
    options: Options(
      followRedirects: false,
      validateStatus: (status) {
        return status! < 600;
      },
    ),
  );

  print('The status code of blm paypal connect is ${response.statusCode}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}