import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiBLMVerificationCodeResend() async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';
  int prefsUserID = sharedPrefs.getInt('blm-user-id');

  final http.Response response = await http.post('http://fbp.dev1.koda.ws/auth/password?/api/v1/users/resend_verification_code?user_id=$prefsUserID&account_type=1',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient, 
    }
  );

  print('The status code for password change is ${response.statusCode}');
  print('The status body for password change is ${response.body}');
  print('The status headers for password change is ${response.headers}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}