import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<String> apiBLMTokenization() async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get(
    'http://fbp.dev1.koda.ws/api/v1/payments/braintree/new',
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
    );

  print('The status code of regular tokenization is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);

    String token = newData['client_token'];
    return token;
  }else{
    return Future.error('Something went wrong. Please try again.');
  }
}