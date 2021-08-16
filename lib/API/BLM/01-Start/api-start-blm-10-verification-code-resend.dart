import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiBLMVerificationCodeResend() async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';
  int prefsUserID = sharedPrefs.getInt('blm-user-id')!;

  Dio dioRequest = Dio();

  // var response = await dioRequest.post('http://fbp.dev1.koda.ws/api/v1/users/resend_verification_code?user_id=$prefsUserID&account_type=1',
  var response = await dioRequest.post('http://45.33.66.25:3001/api/v1/users/resend_verification_code?user_id=$prefsUserID&account_type=1',
    options: Options(
      followRedirects: false,
      validateStatus: (status){
        return status! < 600;
      },
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient, 
      }
    ),
  );

  print('The status code of blm verification code resend is ${response.statusCode}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}