import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<String> apiBLMVerifyEmail({required String verificationCode}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  int prefsUserID = sharedPrefs.getInt('blm-user-id')!;
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.post('https://facesbyplaces.com/api/v1/users/verify_code?user_id=$prefsUserID&verification_code=$verificationCode&account_type=1',
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

  print('The status code in verify email is ${response.statusCode}');
  print('The status data in verify email is ${response.data}');

  if(response.statusCode == 200){
    sharedPrefs.setBool('blm-user-session', true);
    sharedPrefs.setBool('user-guest-session', false);
    return 'Success';
  }else{
    var newData = Map<String, dynamic>.from(response.data);
    return newData['message'];
  }
}