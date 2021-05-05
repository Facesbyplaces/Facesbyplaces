import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiBLMDonate({required String pageType, required int pageId, required double amount, required String token}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();
  FormData formData = FormData();

  formData = FormData.fromMap({
    'page_type': '$pageType',
    'page_id': '$pageId',
    'amount': '5',
    'token': '$token',
  });

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
      },
    ),
    data: formData,
  );

  print('The status code of blm donate is ${response.statusCode}');
  print('The status data of blm donate is ${response.data}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}