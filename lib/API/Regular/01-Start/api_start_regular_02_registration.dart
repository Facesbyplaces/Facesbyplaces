import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<String> apiRegularRegistration({required APIRegularAccountRegistration account}) async{
  Dio dioRequest = Dio();

  var response = await dioRequest.post('https://www.facesbyplaces.com/alm_auth?first_name=${account.firstName}&last_name=${account.lastName}&phone_number=${account.phoneNumber}&email=${account.email}&username=${account.username}&password=${account.password}&account_type=2&question=${account.question}&security_answer=${account.answer}',
    options: Options(
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
      },
      validateStatus: (status){
        return status! < 600;
      },
      followRedirects: false,
    ),  
  );

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    var user = newData['data'];
    int userId = user['id'];
    final sharedPrefs = await SharedPreferences.getInstance();

    sharedPrefs.setInt('regular-user-id', userId);
    sharedPrefs.setString('regular-access-token', response.headers['access-token'].toString().replaceAll(']', '').replaceAll('[', ''));
    sharedPrefs.setString('regular-uid', response.headers['uid'].toString().replaceAll(']', '').replaceAll('[', ''));
    sharedPrefs.setString('regular-client', response.headers['client'].toString().replaceAll(']', '').replaceAll('[', ''));

    return 'Success';
  }else if(response.statusCode == 422){
    var newData = Map<String, dynamic>.from(response.data);
    var errors = newData['errors'];

    return '${errors['full_messages'][0]}.';
  }else{
    return 'Something went wrong. Please try again.';
  }
}

class APIRegularAccountRegistration{
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String username;
  final String password;
  final String question;
  final String answer;
  APIRegularAccountRegistration({required this.firstName, required this.lastName, required this.phoneNumber, required this.email, required this.username, required this.password, required this.question, required this.answer});
}