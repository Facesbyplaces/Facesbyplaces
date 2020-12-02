import 'package:shared_preferences/shared_preferences.dart';

Future<bool> apiBLMLogout() async{

  await Future.delayed(Duration(milliseconds: 1000));

  final sharedPrefs = await SharedPreferences.getInstance();

  sharedPrefs.remove('blm-user-id');
  sharedPrefs.remove('blm-access-token');
  sharedPrefs.remove('blm-uid');
  sharedPrefs.remove('blm-client');
  sharedPrefs.remove('blm-user-session');

  return true;
}