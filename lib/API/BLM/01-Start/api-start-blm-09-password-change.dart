import 'package:http/http.dart' as http;

Future<bool> apiBLMPasswordChange({String password, String passwordConfirmation, String resetToken}) async{

  final http.Response response = await http.put('http://fbp.dev1.koda.ws/auth/password?password=$password&password_confirmation=$passwordConfirmation&reset_password_token=$resetToken',
    headers: <String, String>{
      'Content-Type': 'application/json',
    }
  );

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}