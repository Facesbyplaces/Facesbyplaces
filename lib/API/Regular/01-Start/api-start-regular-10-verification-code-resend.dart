import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiRegularVerificationCodeResend() async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';
  int prefsUserID = sharedPrefs.getInt('regular-user-id');

  final http.Response response = await http.post('http://fbp.dev1.koda.ws/auth/password?/api/v1/users/resend_verification_code?user_id=$prefsUserID&account_type=2',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient, 
    }
  );

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}