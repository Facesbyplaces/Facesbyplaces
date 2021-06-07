import 'package:shared_preferences/shared_preferences.dart';
import 'package:clipboard/clipboard.dart';
import 'package:dio/dio.dart';

Future<bool> apiBLMDonate({required String pageType, required int pageId, required double amount, required String token}) async{

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
  FormData formData = FormData();

  formData = FormData.fromMap({
    'page_type': '$pageType',
    'page_id': '$pageId',
    'amount': '$amount',
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

  FlutterClipboard.copy('${response.data}').then(( value ) => print('copied!'));

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}