import 'package:dio/dio.dart';

Future<bool> apiRegularPaypal() async{

  Dio dioRequest = Dio();

  var response = await dioRequest.get('https://www.sandbox.paypal.com/connect?flowEntry=static&scope=openid profile email&client_id=AdFMd7tGZjQMPhTpOiEZSkK7SYmBAoAY71Mrdjbe9g_JVrlY0_0Df-ncKw4wl__YXNBn15PtdGiQNuUT&response_type=code&redirect_uri=www.google.com',);

  print('The status code of regular paypal is ${response.statusCode}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}