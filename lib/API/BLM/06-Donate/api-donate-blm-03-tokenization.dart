// import 'package:dio/dio.dart';

// Future<String> apiBLMTokenization() async{

//   Dio dioRequest = Dio();

//   var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/payments/braintree/new',);

//   print('The status code of blm tokenization is ${response.statusCode}');

//   if(response.statusCode == 200){
//     var newData = Map<String, dynamic>.from(response.data);

//     String token = newData['client_token'];
//     return token;
//   }else{
//     return Future.error('Something went wrong. Please try again.');
//   }
// }