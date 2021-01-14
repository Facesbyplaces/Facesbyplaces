import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiBLMVerifyEmail({String verificationCode}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  int prefsUserID = sharedPrefs.getInt('blm-user-id');

  final http.Response response = await http.post(
    // 'http://fbp.dev1.koda.ws/api/v1/users/verify?user_id=$prefsUserID&verification_code=$verificationCode',
    'http://fbp.dev1.koda.ws/api/v1/users/verify?user_id=$prefsUserID&verification_code=$verificationCode&account_type=1',
    // /users/verify?user_id=2&verification_code=368&account_type=2
    headers: <String, String>{
      'Content-Type': 'application/json',
    }
  );

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}