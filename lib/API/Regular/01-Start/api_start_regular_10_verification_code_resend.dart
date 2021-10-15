import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiRegularVerificationCodeResend() async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';
  int prefsUserID = sharedPrefs.getInt('regular-user-id')!;

  Dio dioRequest = Dio();

  var response = await dioRequest.post('https://facesbyplaces.com/api/v1/users/resend_verification_code?user_id=$prefsUserID&account_type=2',
    options: Options(
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient, 
      },
      validateStatus: (status){
        return status! < 600;
      },
      followRedirects: false,
    ),  
  );

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}