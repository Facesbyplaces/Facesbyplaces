import 'package:http/http.dart' as http;

Future<bool> apiRegularPasswordReset({required String email, required String redirectLink}) async{

  final http.Response response = await http.post(
    Uri.http('http://fbp.dev1.koda.ws/alm_auth/password?email=$email&redirect_url=$redirectLink', ''),
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