import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiBLMConfirmPayment({required String clientSecret, required String paymentMethod}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  bool userSessionRegular = sharedPrefs.getBool('regular-user-session') ?? false;
  bool userSessionBLM = sharedPrefs.getBool('blm-user-session') ?? false;
  String? getAccessToken;
  String? getUID;
  String? getClient;

  if(userSessionRegular == true){
    getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
    getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
    getClient = sharedPrefs.getString('regular-client') ?? 'empty';
  }else if(userSessionBLM == true){
    getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
    getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
    getClient = sharedPrefs.getString('blm-client') ?? 'empty';
  }


  Dio dioRequest = Dio();

  var response = await dioRequest.post('http://fbp.dev1.koda.ws/api/v1/payments/confirm_payment_intent',
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
    queryParameters: <String, dynamic>{
      'client_secret': '$clientSecret',
      'payment_method': '$paymentMethod',
    },
  );

  print('The status code of blm confirm payment is ${response.statusCode}');
  print('The status data of blm confirm payment is ${response.data}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}