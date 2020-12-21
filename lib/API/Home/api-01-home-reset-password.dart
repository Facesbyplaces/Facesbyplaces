import 'package:http/http.dart' as http;

Future<bool> apiHomeResetPassword({String email, String redirectLink}) async{

  final http.Response response = await http.post(
    'http://fbp.dev1.koda.ws/auth/password?email=$email&redirect_url=$redirectLink',
    headers: <String, String>{
      'Content-Type': 'application/json',
    }
  );

  print('The status code on password reset is ${response.statusCode}');
  print('The status body on password resetis ${response.body}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}