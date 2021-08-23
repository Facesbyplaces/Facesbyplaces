import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<String> apiRegularVerifyEmail({required String verificationCode}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  int prefsUserID = sharedPrefs.getInt('regular-user-id')!;
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  // var response = await dioRequest.post('http://45.33.66.25:3001/api/v1/users/verify_code?user_id=$prefsUserID&verification_code=$verificationCode&account_type=2',
  var response = await dioRequest.post('http://facesbyplaces.com/api/v1/users/verify_code?user_id=$prefsUserID&verification_code=$verificationCode&account_type=2',
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