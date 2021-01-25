import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMDonateMain> apiBLMDonate({String pageType, int pageId, double amount, String token}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  print('hehehehe');

  print('The pageType is $pageType');
  print('The pageId is $pageId');
  print('The amount is $amount');
  print('The token is $token');

  final http.Response response = await http.post(
    'http://fbp.dev1.koda.ws/api/v1/payment_intent',
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

  print('The donation in blm donate is ${response.statusCode}');
  print('The donation in blm donate is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMDonateMain.fromJson(newValue);
  }else{
    throw Exception('Failed to process donation.');
  }
}

class APIBLMDonateMain{
  String stripeAccount;
  String pKey;
  String clientSecret;
  String paymentIntent;

  APIBLMDonateMain({this.stripeAccount, this.pKey, this.clientSecret, this.paymentIntent});

  factory APIBLMDonateMain.fromJson(Map<String, dynamic> parsedJson){

    return APIBLMDonateMain(
      stripeAccount: parsedJson['memorial_stripe_account'] != null ? parsedJson['memorial_stripe_account'] : '',
      pKey: parsedJson['publishable_key'] != null ? parsedJson['publishable_key'] : '',
      clientSecret: parsedJson['client_secret'] != null ? parsedJson['client_secret'] : '',
      paymentIntent: parsedJson['id'] != null ? parsedJson['id'] : '',
    );
  }
}
