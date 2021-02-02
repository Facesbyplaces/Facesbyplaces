import 'package:http/http.dart' as http;

Future<bool> apiRegularSignInAsGuest() async{

  final http.Response response = await http.post('http://fbp.dev1.koda.ws//api/v1/users/signin-guest',
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