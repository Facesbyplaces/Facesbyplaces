import 'package:http/http.dart' as http;

Future<bool> apiBLMLogin(String email, String password) async{

  final http.Response response = await http.post(
    'http://fbp.dev1.koda.ws/auth/sign_in?email=$email&password=$password',
    headers: <String, String>{
      'Content-Type': 'application/json',
    }
  );

  print('The headers is ${response.headers}');
  print('The response status in login blm is ${response.statusCode}');
  print('The response status in login blm is ${response.body}');


  if(response.statusCode == 200){
      // var value = json.decode(response.body);
      // var user = value['user'];
      // var userId = user['id'];
      // var userEmail = user['email'];

      // final sharedPrefs = await SharedPreferences.getInstance();

      // sharedPrefs.setInt('blm-user-id', userId);
      // sharedPrefs.setString('blm-user-email', userEmail);
      // sharedPrefs.setString('blm-access-token', response.headers['access-token']);
      // sharedPrefs.setString('blm-uid', response.headers['uid']);    
      // sharedPrefs.setString('blm-client', response.headers['client']);
      // sharedPrefs.setBool('blm-session', true);
    return true;
  }else{
    return false;
  }
}