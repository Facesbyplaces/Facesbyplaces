import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiBLMProcessToken({required String amount, required String nonce, required String deviceData}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  try{
    var response = await dioRequest.post('http://fbp.dev1.koda.ws/api/v1/payments/braintree/appleOrGooglePay?amount=$amount&payment_method_nonce=$nonce&device_data=$deviceData',
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status! < 600;
        },
        headers: <String, dynamic>{
          'Content-Type': 'application/json',
          'access-token': getAccessToken,
          'uid': getUID,
          'client': getClient,
        }
      ),
    );

    print('The status code of regular process payment is ${response.statusCode}');
    print('The status data of regular process payment is ${response.data}');

    if(response.statusCode == 200){
      return true;
    }else{
      return false;
    }
  }catch(e){
    // return Future.error('The error is $e');
    throw Exception('The error is $e');
  }
}