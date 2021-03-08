import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> apiRegularRegistration({required APIRegularAccountRegistration account}) async{

  String result = 'Success';

  try{
    final http.Response response = await http.post(
      // 'http://fbp.dev1.koda.ws/alm_auth?first_name=${account.firstName}&last_name=${account.lastName}&phone_number=${account.phoneNumber}&email=${account.email}&username=${account.username}&password=${account.password}&account_type=2',
      Uri.http('http://fbp.dev1.koda.ws/alm_auth?first_name=${account.firstName}&last_name=${account.lastName}&phone_number=${account.phoneNumber}&email=${account.email}&username=${account.username}&password=${account.password}&account_type=2', ''),
      headers: <String, String>{
        'Content-Type': 'application/json',
      }
    );

    if(response.statusCode == 200){
      var value = json.decode(response.body);
      var user = value['data'];
      int userId = user['id'];
      String verificationCode = user['verification_code'];

      final sharedPrefs = await SharedPreferences.getInstance();

      sharedPrefs.setInt('regular-user-id', userId);
      sharedPrefs.setString('regular-verification-code', verificationCode);
      sharedPrefs.setString('regular-access-token', response.headers['access-token']!);
      sharedPrefs.setString('regular-uid', response.headers['uid']!);
      sharedPrefs.setString('regular-client', response.headers['client']!);

    }else{
      var value = json.decode(response.body);
      var data = value['errors'];
      String message = data['full_messages'][0];

      result = message;
    }
  }catch(e){
    print('Error in registration: $e');
    result = 'Something went wrong. Please try again.';
  }

  return result;
}

class APIRegularAccountRegistration{
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String username;
  String password;

  APIRegularAccountRegistration({required this.firstName, required this.lastName, required this.phoneNumber, required this.email, required this.username, required this.password});
}