import 'package:dio/dio.dart';
import 'dart:convert';

Future<String> apiBLMMemorialPaypalAccessToken({required String code}) async{

  Dio dioRequest = Dio();
  var auth = 'Basic '+base64Encode(utf8.encode('AdFMd7tGZjQMPhTpOiEZSkK7SYmBAoAY71Mrdjbe9g_JVrlY0_0Df-ncKw4wl__YXNBn15PtdGiQNuUT:ELQ49uFroNvBtx-DUQ1uIiLv4vpEMk5WM7VRqzq92KANWsTgHe6SJdAibXqAulq4g9tSixZPFrLzCN0m'));

  Map<String, String> data = {
    'grant_type': 'authorization_code',
    'code': '$code',
  };

  var response = await dioRequest.post('https://api-m.sandbox.paypal.com/v1/oauth2/token',
    options: Options(
      followRedirects: false,
      validateStatus: (status) {
        return status! < 600;
      },
      headers: <String, String>{'authorization': auth},
      contentType: Headers.formUrlEncodedContentType,
    ),
    data: data
  );

  print('The status code of blm paypal access token is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return newData['access_token'];
  }else{
    throw Exception('Failed to get the paypal access token');
  }
}