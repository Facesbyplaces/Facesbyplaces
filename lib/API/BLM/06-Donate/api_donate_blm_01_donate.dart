import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<List<String>> apiBLMDonate({required String pageType, required int pageId, required double amount, required String paymentMethod}) async{
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

  var response = await dioRequest.post('https://facesbyplaces.com/api/v1/payments/payment_intent',
    options: Options(
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      },
      validateStatus: (status){
        return status! < 600;
      },
      followRedirects: false,
    ),
    queryParameters: <String, dynamic>{
      'page_type': pageType,
      'page_id': pageId,
      'amount': amount,
      'payment_method': paymentMethod,
    },
  );

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    if(paymentMethod != ''){
      String clientSecret = newData['payment_intent'];
      String paymentMethod = newData['payment_method'];
      return [clientSecret, paymentMethod];
    }else{
      String clientSecret = newData['client_secret'];
      return [clientSecret, ''];
    }
  }else{
    throw Exception('Something went wrong. Please try again.');
  }
}