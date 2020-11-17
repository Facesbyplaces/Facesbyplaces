import 'package:http/http.dart' as http;

Future<bool> apiBLMRegistration(APIBLMAccountRegistration account) async{

  print('The first name is ${account.firstName}');

  final http.Response response = await http.post(
    // 'https://01244d89dd6fd9fd5dae11b6ec419531.m.pipedream.net',
    'http://fbp.dev1.koda.ws/auth?first_name=${account.firstName}&last_name=${account.lastName}&phone_number=${account.phoneNumber}&email=${account.email}&username=${account.username}&password=${account.password}',
    // http://fbp.dev1.koda.ws/auth?first_name=Marlon&last_name=Marcuelo&phone_number=1234567890&email=marcuelo2@gmail.com&username=marlon&password=marcuelo2
    headers: <String, String>{
      'Content-Type': 'application/json',
    }
  );

  print('The response status is ${response.statusCode}');
  print('The response status is ${response.body}');

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

class APIBLMAccountRegistration{
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String username;
  String password;

  APIBLMAccountRegistration({this.firstName, this.lastName, this.phoneNumber, this.email, this.username, this.password});
}