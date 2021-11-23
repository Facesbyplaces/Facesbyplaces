import 'package:dio/dio.dart';

Future<bool> apiBLMMemorialPaypalConnect({required String userId, required String name, required String email, required int memorialId}) async{
  Dio dioRequest = Dio();

  var response = await dioRequest.post('https://www.facesbyplaces.com/api/v1/payments/braintree?paypal_user_id=$userId&paypalable_id=$memorialId&paypalable_type=Blm&name=$name&email=$email',
    options: Options(
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