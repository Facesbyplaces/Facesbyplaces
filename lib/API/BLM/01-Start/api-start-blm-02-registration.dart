import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> apiBLMRegistration(APIBLMAccountRegistration account) async{

  String result = 'Success';

  try{
    final http.Response response = await http.post(
      'http://fbp.dev1.koda.ws/auth?first_name=${account.firstName}&last_name=${account.lastName}&phone_number=${account.phoneNumber}&email=${account.email}&username=${account.username}&password=${account.password}&account_type=1',
      headers: <String, String>{
        'Content-Type': 'application/json',
      }
    );

    print('The response status in blm registration is ${response.statusCode}');
    print('The response body in blm registration is ${response.body}');
    
    if(response.statusCode == 200){
      var value = json.decode(response.body);
      var user = value['data'];
      int userId = user['id'];
      String verificationCode = user['verification_code'];

      final sharedPrefs = await SharedPreferences.getInstance();

      sharedPrefs.setInt('blm-user-id', userId);
      sharedPrefs.setString('blm-verification-code', verificationCode);
      sharedPrefs.setString('blm-access-token', response.headers['access-token']);
      sharedPrefs.setString('blm-uid', response.headers['uid']);    
      sharedPrefs.setString('blm-client', response.headers['client']);
      sharedPrefs.setBool('blm-user-verify', true);
      
    }else{
      var value = json.decode(response.body);
      var data = value['errors'];
      String message = data['full_messages'][0];

      result = message;
    }
  }catch(e){
    result = 'Something went wrong. Please try again.';
  }

  return result;
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