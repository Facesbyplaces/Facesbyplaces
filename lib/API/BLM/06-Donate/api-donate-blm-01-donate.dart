import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiBLMDonate({required String pageType, required int pageId, required double amount, required String token}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  print('The page type is $pageType');
  print('The pageId is $pageId');
  print('The amount is $amount');
  print('The token is $token');

  Dio dioRequest = Dio();
  FormData formData = FormData();

  formData = FormData.fromMap({
    'page_type': '$pageType',
    'page_id': '$pageId',
    'amount': '5',
    'token': '$token',
  });

  var response = await dioRequest.post(
    // 'http://fbp.dev1.koda.ws/api/v1/payment_intent',
    'http://fbp.dev1.koda.ws/api/v1/payments/payment_intent',
    options: Options(
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      },
    ),
    data: formData,
  );

  print('The status code of regular donate is ${response.statusCode}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}