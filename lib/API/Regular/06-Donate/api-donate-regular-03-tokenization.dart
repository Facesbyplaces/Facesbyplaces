import 'package:dio/dio.dart';

Future<String> apiRegularTokenization() async{

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/payments/paypal/new',);

  print('The status code of regular paypal is ${response.statusCode}');
  print('The status data of regular paypal is ${response.data}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);

    String token = newData['client_token'];
    // print('The token is $token');
    return token;
  }else{
    return Future.error('Something went wrong. Please try again.');
  }
}