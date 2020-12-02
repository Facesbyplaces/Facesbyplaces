import 'package:shared_preferences/shared_preferences.dart';

Future<bool> apiRegularLogout() async{

  await Future.delayed(Duration(milliseconds: 1000));

  final sharedPrefs = await SharedPreferences.getInstance();

  sharedPrefs.remove('regular-user-id');
  sharedPrefs.remove('regular-access-token');
  sharedPrefs.remove('regular-uid');
  sharedPrefs.remove('regular-client');
  sharedPrefs.remove('regular-user-session');

  return true;
}