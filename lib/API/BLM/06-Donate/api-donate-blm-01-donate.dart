import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiBLMDonate({required String pageType, required int pageId, required double amount, required String token}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';
  
  final http.Response response = await http.post(
    Uri.http('http://fbp.dev1.koda.ws/api/v1/payment_intent', ''),
    headers: <String, String>{
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    },
    body: <String, dynamic>{
      'page_type': '$pageType',
      'page_id': '$pageId',
      'amount': '$amount',
      'token': '$token',
    }
  );

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}