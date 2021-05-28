import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<String> apiBLMVerifyEmail({required String verificationCode}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  int prefsUserID = sharedPrefs.getInt('blm-user-id')!;
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.post('http://fbp.dev1.koda.ws/api/v1/users/verify?user_id=$prefsUserID&verification_code=$verificationCode&account_type=1', 
    options: Options(
      followRedirects: false,
      validateStatus: (status) {
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

  print('The status code of blm verify email is ${response.statusCode}');

  if(response.statusCode == 200){
    sharedPrefs.setBool('blm-user-session', true);
    sharedPrefs.setBool('user-guest-session', false);
    return 'Success';
  }else{
    var newData = Map<String, dynamic>.from(response.data);
    return newData['message'];
  }
}