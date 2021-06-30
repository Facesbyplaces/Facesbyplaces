import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<List<String>> apiRegularDonate({required String pageType, required int pageId, required double amount, required String paymentMethod}) async{

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
  // print('The status data of regular donate is ${response.headers}');

  if(response.statusCode == 200 || response.statusCode == 422){
    var newData = Map<String, dynamic>.from(response.data);
    if(paymentMethod != ''){
      String clientSecret = newData['payment_intent'];
      String paymentMethod = newData['payment_method'];

      print('The clientSecret is $clientSecret');
      print('The payment_method is $paymentMethod');

      return [clientSecret, paymentMethod];
    }else{
      String clientSecret = newData['intent'];

      print('The clientSecret is $clientSecret');
      return [clientSecret, ''];
    }
  }else{
    throw Exception('Something went wrong. Please try again.');
  }
}