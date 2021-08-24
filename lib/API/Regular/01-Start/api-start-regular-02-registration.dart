import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<String> apiRegularRegistration({required APIRegularAccountRegistration account}) async{
  Dio dioRequest = Dio();

  var response = await dioRequest.post('http://facesbyplaces.com/alm_auth?first_name=${account.firstName}&last_name=${account.lastName}&phone_number=${account.phoneNumber}&email=${account.email}&username=${account.username}&password=${account.password}&account_type=2',
    options: Options(
      followRedirects: false,
      validateStatus: (status){
        return status! < 600;
      },
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
      }
    ),  
  );

  print('The status code of regular registration is ${response.statusCode}');
  print('The status data of regular registration is ${response.data}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    var user = newData['data'];
    int userId = user['id'];
    final sharedPrefs = await SharedPreferences.getInstance();

    print('The value of data in regular registration is $user');

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
  APIRegularAccountRegistration({required this.firstName, required this.lastName, required this.phoneNumber, required this.email, required this.username, required this.password});
}