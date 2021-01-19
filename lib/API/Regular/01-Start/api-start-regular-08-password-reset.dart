import 'package:http/http.dart' as http;

Future<bool> apiRegularPasswordReset({String email, String redirectLink}) async{

  final http.Response response = await http.post(
    // 'http://fbp.dev1.koda.ws/auth/password?email=$email&redirect_url=$redirectLink',
    'http://fbp.dev1.koda.ws/alm_auth/password?email=$email&redirect_url=$redirectLink',
    headers: <String, String>{
      'Content-Type': 'application/json',
    }
  );

  print('The reset password in regular status code is ${response.statusCode}');
  print('The reset password in regular status body is ${response.body}');
  print('The reset headers in regular status body is ${response.headers}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}