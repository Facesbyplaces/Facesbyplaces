import 'package:http/http.dart' as http;

Future<bool> apiBLMPasswordReset({String email, String redirectLink}) async{

  final http.Response response = await http.post('http://fbp.dev1.koda.ws/auth/password?email=$email&redirect_url=$redirectLink',
    headers: <String, String>{
      'Content-Type': 'application/json',
    }
  );

  print('The status code for password reset is ${response.statusCode}');
  print('The status body for password reset is ${response.body}');
  print('The status headers for password reset is ${response.headers}');

  if(response.statusCode == 200){

    return true;
  }else{
    return false;
  }
}