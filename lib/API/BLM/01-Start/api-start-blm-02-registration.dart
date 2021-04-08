import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<String> apiBLMRegistration({required APIBLMAccountRegistration account}) async{

  String result = 'Success';

  try{
    Dio dioRequest = Dio();

    var response = await dioRequest.post('http://fbp.dev1.koda.ws/auth?first_name=${account.firstName}&last_name=${account.lastName}&phone_number=${account.phoneNumber}&email=${account.email}&username=${account.username}&password=${account.password}&account_type=1', 
      options: Options(
        headers: <String, dynamic>{
          'Content-Type': 'application/json',
        }
      ),  
    );

    if(response.statusCode == 200){
      var newData = Map<String, dynamic>.from(response.data);
      var user = newData['data'];
      int userId = user['id'];
      String verificationCode = user['verification_code'];

      final sharedPrefs = await SharedPreferences.getInstance();

      sharedPrefs.setInt('blm-user-id', userId);
      sharedPrefs.setString('blm-verification-code', verificationCode);
      sharedPrefs.setString('blm-access-token', response.headers['access-token'].toString().replaceAll(']', '').replaceAll('[', ''));
      sharedPrefs.setString('blm-uid', response.headers['uid'].toString().replaceAll(']', '').replaceAll('[', ''));
      sharedPrefs.setString('blm-client', response.headers['client'].toString().replaceAll(']', '').replaceAll('[', ''));
    }else{
      var newData = Map<String, dynamic>.from(response.data);
      var user = newData['data'];
      String message = user['full_messages'][0];

      result = message; 
    }
  }catch(e){
    print('Error in registration: $e');
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

  APIBLMAccountRegistration({required this.firstName, required this.lastName, required this.phoneNumber, required this.email, required this.username, required this.password});
}