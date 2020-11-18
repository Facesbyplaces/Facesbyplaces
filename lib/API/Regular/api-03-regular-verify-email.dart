import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiRegularVerifyEmail(String verificationCode) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  int prefsUserID = sharedPrefs.getInt('regular-user-id');

  final http.Response response = await http.post(
    'http://fbp.dev1.koda.ws/api/v1/users/verify?user_id=$prefsUserID&verification_code=$verificationCode',
    headers: <String, String>{
      'Content-Type': 'application/json',
    }
  );

  // print('The response in regular status is ${response.statusCode}');
  // print('The response in regular status is ${response.body}');

  if(response.statusCode == 200){
    sharedPrefs.setString('regular-access-token', response.headers['access-token']);
    sharedPrefs.setString('regular-uid', response.headers['uid']);    
    sharedPrefs.setString('regular-client', response.headers['client']);
    return true;
  }else{
    return false;
  }
}