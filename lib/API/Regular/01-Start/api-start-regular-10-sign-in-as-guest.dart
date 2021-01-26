import 'package:http/http.dart' as http;

Future<bool> apiRegularSignInAsGuest() async{

  final http.Response response = await http.post('http://fbp.dev1.koda.ws//api/v1/users/signin-guest',
    headers: <String, String>{
      'Content-Type': 'application/json',
    }
  );

  print('The status code of guest login in alm is ${response.statusCode}');
  print('The status body of guest login in alm is ${response.body}');
  print('The status headers of guest login in alm is ${response.headers}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}