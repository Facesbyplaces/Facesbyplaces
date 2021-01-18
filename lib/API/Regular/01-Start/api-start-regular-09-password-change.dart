// /alm_auth/password?password=fyodor789&password_confirmation=fyodor789&reset_password_token=reset_password_token

import 'package:http/http.dart' as http;

Future<bool> apiRegularPasswordChange({String password, String passwordConfirmation, String resetToken}) async{

  final http.Response response = await http.put(
    'http://fbp.dev1.koda.ws/alm_auth/password?password=$password&password_confirmation=$passwordConfirmation&reset_password_token=reset_password_token',
    headers: <String, String>{
      'Content-Type': 'application/json',
    }
  );

  print('The reset password in regular status code is ${response.statusCode}');
  print('The reset password in regular status body is ${response.body}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}