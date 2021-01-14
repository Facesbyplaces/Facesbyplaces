import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiBLMVerifyEmail({String verificationCode}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  int prefsUserID = sharedPrefs.getInt('blm-user-id');

  print('The prefsUserId is $prefsUserID');

  final http.Response response = await http.post(
    'http://fbp.dev1.koda.ws/api/v1/users/verify?user_id=$prefsUserID&verification_code=$verificationCode&account_type=1',
    headers: <String, String>{
      'Content-Type': 'application/json',
    }
  );

  print('The response status code in blm verify email is ${response.statusCode}');
  print('The response status data in blm verify email is ${response.body}');
  print('The headers in verify email is ${response.headers}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}