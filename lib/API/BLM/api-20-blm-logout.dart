import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiBLMLogout() async{

  final sharedPrefs = await SharedPreferences.getInstance();
  var getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  var getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  var getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  print('The access token $getAccessToken');
  print('The UID $getUID');
  print('The client $getClient');

  final http.Response response = await http.delete(
    'http://fbp.dev1.koda.ws/auth/sign_out',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The status code on blm logout is ${response.statusCode}');
  print('The status body on blm logout is ${response.body}');

  if(response.statusCode == 200){

    sharedPrefs.remove('blm-user-id');
    sharedPrefs.remove('blm-access-token');
    sharedPrefs.remove('blm-uid');
    sharedPrefs.remove('blm-client');
    sharedPrefs.remove('blm-user-session');

    sharedPrefs.remove('regular-user-id');
    sharedPrefs.remove('regular-access-token');
    sharedPrefs.remove('regular-uid');
    sharedPrefs.remove('regular-client');
    sharedPrefs.remove('regular-user-session');

    return true;
  }else{
    return false;
  }
}