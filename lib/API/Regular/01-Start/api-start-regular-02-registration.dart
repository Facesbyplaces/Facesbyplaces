import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<String> apiRegularRegistration({required APIRegularAccountRegistration account}) async{

  String result = 'Something went wrong. Please try again.';

  try{
    Dio dioRequest = Dio();

    var response = await dioRequest.post('http://fbp.dev1.koda.ws/alm_auth?first_name=${account.firstName}&last_name=${account.lastName}&phone_number=${account.phoneNumber}&email=${account.email}&username=${account.username}&password=${account.password}&account_type=2',
      options: Options(
        headers: <String, dynamic>{
          'Content-Type': 'application/json',
        }
      ),  
    );

    print('The status code of registration is ${response.statusCode}');

    if(response.statusCode == 200){
      var newData = Map<String, dynamic>.from(response.data);
      var user = newData['data'];
      int userId = user['id'];
      String verificationCode = user['verification_code'];

      final sharedPrefs = await SharedPreferences.getInstance();

      sharedPrefs.setInt('regular-user-id', userId);
      sharedPrefs.setString('regular-verification-code', verificationCode);
      sharedPrefs.setString('regular-access-token', response.headers['access-token'].toString().replaceAll(']', '').replaceAll('[', ''));
      sharedPrefs.setString('regular-uid', response.headers['uid'].toString().replaceAll(']', '').replaceAll('[', ''));
      sharedPrefs.setString('regular-client', response.headers['client'].toString().replaceAll(']', '').replaceAll('[', ''));
      result = 'Success';
    }
    return result;
  }catch(e){
    print('The error of registration is: $e');
    return result;
  }
}

class APIRegularAccountRegistration{
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String username;
  final String password;

  APIRegularAccountRegistration({required this.firstName, required this.lastName, required this.phoneNumber, required this.email, required this.username, required this.password});
}