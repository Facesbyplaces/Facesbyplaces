
import 'package:http/http.dart' as http;

Future<bool> apiBLMPasswordChange({String password, String passwordConfirmation, String resetToken}) async{

  print('The password is $password');
  print('The password confirmation is $passwordConfirmation');
  print('The reset token is $resetToken');

  final http.Response response = await http.put(
    'http://fbp.dev1.koda.ws/auth/password?password=$password&password_confirmation=$passwordConfirmation&reset_password_token=$resetToken',
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