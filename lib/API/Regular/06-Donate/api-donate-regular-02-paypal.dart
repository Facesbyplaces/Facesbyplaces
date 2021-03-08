import 'package:http/http.dart' as http;

Future<bool> apiRegularPaypal({required String pageType, required int pageId, required double amount, required String token}) async{

  final http.Response response = await http.get(
    Uri.http('https://www.sandbox.paypal.com/connect?flowEntry=static&scope=openid profile email&client_id=AdFMd7tGZjQMPhTpOiEZSkK7SYmBAoAY71Mrdjbe9g_JVrlY0_0Df-ncKw4wl__YXNBn15PtdGiQNuUT&response_type=code&redirect_uri=www.google.com', ''),
  );

  print('The status code of paypal is ${response.statusCode}');
  print('The status code of paypal is ${response.body}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}