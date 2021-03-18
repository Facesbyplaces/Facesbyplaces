import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

Future<bool> apiRegularVerificationCodeResend() async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';
  int prefsUserID = sharedPrefs.getInt('regular-user-id')!;

  // final http.Response response = await http.post(
  //   Uri.http('http://fbp.dev1.koda.ws/auth/password?/api/v1/users/resend_verification_code?user_id=$prefsUserID&account_type=2', ''),
  //   headers: <String, String>{
  //     'Content-Type': 'application/json',
  //     'access-token': getAccessToken,
  //     'uid': getUID,
  //     'client': getClient, 
  //   }
  // );

  // if(response.statusCode == 200){
  //   return true;
  // }else{
  //   return false;
  // }

  bool result = false;

  try{
    Dio dioRequest = Dio();

    var response = await dioRequest.post('http://fbp.dev1.koda.ws/auth/password?/api/v1/users/resend_verification_code?user_id=$prefsUserID&account_type=2',
      options: Options(
        headers: <String, dynamic>{
          'Content-Type': 'application/json',
          'access-token': getAccessToken,
          'uid': getUID,
          'client': getClient, 
        }
      ),  
    );

    print('The status code of verification code resend is ${response.statusCode}');

    if(response.statusCode == 200){
      result = true;
    }
    return result;
  }catch(e){
    print('The error of verification code resend is: $e');
    return result;
  }
}