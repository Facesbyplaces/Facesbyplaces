import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
// import 'dart:convert';

Future<bool> apiRegularDonate({String pageType, int pageId, double amount, String token}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

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

  print('The donation in regular donate is ${response.statusCode}');
  print('The donation in regular donate is ${response.body}');

  if(response.statusCode == 200){
    // var newValue = json.decode(response.body);
    // return APIRegularDonateMain.fromJson(newValue);
    return true;
  }else{
    // throw Exception('Failed to process donation.');
    return false;
  }
}

// class APIRegularDonateMain{
//   String stripeAccount;
//   String pKey;
//   String clientSecret;
//   String paymentIntent;

//   APIRegularDonateMain({this.stripeAccount, this.pKey, this.clientSecret, this.paymentIntent});

//   factory APIRegularDonateMain.fromJson(Map<String, dynamic> parsedJson){

//     return APIRegularDonateMain(
//       stripeAccount: parsedJson['memorial_stripe_account'] != null ? parsedJson['memorial_stripe_account'] : '',
//       pKey: parsedJson['publishable_key'] != null ? parsedJson['publishable_key'] : '',
//       clientSecret: parsedJson['client_secret'] != null ? parsedJson['client_secret'] : '',
//       paymentIntent: parsedJson['id'] != null ? parsedJson['id'] : '',
//     );
//   }
// }
