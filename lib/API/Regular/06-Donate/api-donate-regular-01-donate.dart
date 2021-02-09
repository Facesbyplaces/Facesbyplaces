import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiRegularDonate({String pageType, int pageId, double amount, String token}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.post('http://fbp.dev1.koda.ws/api/v1/payment_intent',
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