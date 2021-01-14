import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> apiRegularRegistration({APIRegularAccountRegistration account}) async{

  String result = 'Success';

  try{

    final http.Response response = await http.post(
      // 'http://fbp.dev1.koda.ws/auth?first_name=${account.firstName}&last_name=${account.lastName}&phone_number=${account.phoneNumber}&email=${account.email}&username=${account.username}&password=${account.password}&account_type=2',
      
      // 'http://fbp.dev1.koda.ws/auth/alm_auth?first_name=${account.firstName}&last_name=${account.lastName}&phone_number=${account.phoneNumber}&email=${account.email}&username=${account.username}&password=${account.password}&account_type=2',
      'http://fbp.dev1.koda.ws/alm_auth?first_name=${account.firstName}&last_name=${account.lastName}&phone_number=${account.phoneNumber}&email=${account.email}&username=${account.username}&password=${account.password}&account_type=2',
      headers: <String, String>{
        'Content-Type': 'application/json',
      }
    );

    print('The response code of registration is ${response.statusCode}');
    print('The response body of registration is ${response.body}');
    print('The headers is ${response.headers}');
    print('The access token is ${response.headers['regular-access-token']}');
    print('The uid is ${response.headers['regular-uid']}');
    print('The client is ${response.headers['regular-client']}');

    if(response.statusCode == 200){
      var value = json.decode(response.body);
      var user = value['user'];
      int userId = user['id'];
      String verificationCode = user['verification_code'];

      final sharedPrefs = await SharedPreferences.getInstance();

      

      sharedPrefs.setInt('regular-user-id', userId);
      sharedPrefs.setString('regular-verification-code', verificationCode);


      // sharedPrefs.setBool('regular-user-verify', true);

    }else{
      var value = json.decode(response.body);
      var data = value['errors'];
      String message = data['full_messages'][0];

      result = message;
    }
  }catch(e){
    print('The e is $e');
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

  APIRegularAccountRegistration({this.firstName, this.lastName, this.phoneNumber, this.email, this.username, this.password});
}