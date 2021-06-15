import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<String> apiRegularDonate({required String pageType, required int pageId, required double amount, required String paymentMethod}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.post('http://fbp.dev1.koda.ws/api/v1/payments/payment_intent',
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
      'page_type': '$pageType',
      'page_id': '$pageId',
      'amount': '$amount',
      'payment_method': '$paymentMethod',
    },
  );

  print('The status code of regular donate is ${response.statusCode}');
  print('The status data of regular donate is ${response.data}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    var paymentIntent = newData['payment_intent'];
    String clientSecret = paymentIntent['client_secret'];

    print('The clientSecret is $clientSecret');

    return clientSecret;
  }else{
    throw Exception('Something went wrong. Please try again.');
  }
}