import 'package:http/http.dart' as http;

Future<bool> apiHomeResetPassword({String email, String redirectLink}) async{

  final http.Response response = await http.post('http://fbp.dev1.koda.ws/auth/password?email=$email&redirect_url=$redirectLink',
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