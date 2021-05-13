import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<String> apiRegularVerifyEmail({required String verificationCode}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  int prefsUserID = sharedPrefs.getInt('regular-user-id')!;

  print('The user id is $prefsUserID');
  print('The verification code is $verificationCode');

  Dio dioRequest = Dio();

  var response = await dioRequest.post('http://fbp.dev1.koda.ws/api/v1/users/verify?user_id=$prefsUserID&verification_code=$verificationCode&account_type=2',
    options: Options(
      followRedirects: false,
      validateStatus: (status) {
        return status! < 600;
      },
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
      }
    ),  
  );

  print('The status code of regular verify email is ${response.statusCode}');

  if(response.statusCode == 200){
    sharedPrefs.setBool('regular-user-session', true);
    sharedPrefs.setBool('user-guest-session', false);
    return 'Success';
  }else{
    var newData = Map<String, dynamic>.from(response.data);
    return newData['message'];
  }
}