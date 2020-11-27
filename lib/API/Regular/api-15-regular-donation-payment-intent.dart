import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> apiRegularDonate(int amount) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  int memorialId = sharedPrefs.getInt('regular-user-memorial-id') ?? 0;
  var getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  var getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  var getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.post(
    'http://fbp.dev1.koda.ws/api/v1/payment_intent?memorial_id=$memorialId&memorial_id=$memorialId&amount=$amount',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The response status in donation is ${response.statusCode}');
  print('The response status in donation is ${response.body}');

  if(response.statusCode == 200){
    var value = json.decode(response.body);
    var clientSecret = value['client_secret'];

    print('The client secret is $clientSecret');
    
    return clientSecret.toString();
  }else{
    throw Exception('Failed to get the feed');
  }
}
