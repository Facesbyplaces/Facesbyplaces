import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiBLMVerifyEmail(String verificationCode) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  int prefsUserID = sharedPrefs.getInt('blm-user-id');

  final http.Response response = await http.post(
    'http://fbp.dev1.koda.ws/api/v1/users/verify?user_id=$prefsUserID&verification_code=$verificationCode',
    headers: <String, String>{
      'Content-Type': 'application/json',
    }
  );

    print('The response status in blm verify email is ${response.statusCode}');
    print('The response body in blm verify email is ${response.body}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}