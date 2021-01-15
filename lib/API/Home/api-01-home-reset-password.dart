import 'package:http/http.dart' as http;

Future<bool> apiHomeResetPassword({String email, String redirectLink}) async{

  final http.Response response = await http.post(
    // 'http://fbp.dev1.koda.ws/auth/password?email=$email&redirect_url=$redirectLink',
    'http://fbp.dev1.koda.ws/users/password?email=$email&redirect_url=$redirectLink',
    headers: <String, String>{
      'Content-Type': 'application/json',
    }
  );

  print('The reset password status code is ${response.statusCode}');
  print('The reset password status body is ${response.body}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}