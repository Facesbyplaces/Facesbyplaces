import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

Future<bool> apiRegularPasswordChange({required String password, required String passwordConfirmation, required String resetToken}) async{

  // final http.Response response = await http.put(
  //   Uri.http('http://fbp.dev1.koda.ws/alm_auth/password?password=$password&password_confirmation=$passwordConfirmation&reset_password_token=$resetToken', ''),
  //   headers: <String, String>{
  //     'Content-Type': 'application/json',
  //   }
  // );

  // if(response.statusCode == 200){
  //   var value = json.decode(response.body);
  //   var user = value['data'];
  //   int userId = user['id'];

  //   final sharedPrefs = await SharedPreferences.getInstance();

  //   sharedPrefs.setInt('regular-user-id', userId);
  //   sharedPrefs.setString('regular-access-token', response.headers['access-token']!);
  //   sharedPrefs.setString('regular-uid', response.headers['uid']!);
  //   sharedPrefs.setString('regular-client', response.headers['client']!);
  //   sharedPrefs.setBool('regular-user-session', true);

  //   return true;
  // }else{
  //   return false;
  // }

  Dio dioRequest = Dio();

  var response = await dioRequest.put('http://fbp.dev1.koda.ws/alm_auth/password?password=$password&password_confirmation=$passwordConfirmation&reset_password_token=$resetToken',);

  print('The status code of password change is ${response.statusCode}');

  if(response.statusCode == 200){
    // var value = json.decode(response.data);
    // var user = value['data'];
    // int userId = user['id'];

    var newData = Map<String, dynamic>.from(response.data);

    print('The newData is $newData');

    var user = newData['data'];
    int userId = user['id'];

    // final sharedPrefs = await SharedPreferences.getInstance();

    // sharedPrefs.setInt('blm-user-id', userId);
    // // sharedPrefs.setString('blm-access-token', response.headers['access-token']!);
    // // sharedPrefs.setString('blm-uid', response.headers['uid']!);
    // // sharedPrefs.setString('blm-client', response.headers['client']!);
    // sharedPrefs.setString('blm-access-token', response.headers['access-token'].toString().replaceAll(']', '').replaceAll('[', ''));
    // sharedPrefs.setString('blm-uid', response.headers['uid'].toString().replaceAll(']', '').replaceAll('[', ''));
    // sharedPrefs.setString('blm-client', response.headers['client'].toString().replaceAll(']', '').replaceAll('[', ''));
    // sharedPrefs.setBool('blm-user-session', true);

    final sharedPrefs = await SharedPreferences.getInstance();

    sharedPrefs.setInt('regular-user-id', userId);
    sharedPrefs.setString('regular-access-token', response.headers['access-token'].toString().replaceAll(']', '').replaceAll('[', ''));
    sharedPrefs.setString('regular-uid', response.headers['uid'].toString().replaceAll(']', '').replaceAll('[', ''));
    sharedPrefs.setString('regular-client', response.headers['client'].toString().replaceAll(']', '').replaceAll('[', ''));
    sharedPrefs.setBool('regular-user-session', true);
    
    return true;
  }else{
    return false;
  }
}