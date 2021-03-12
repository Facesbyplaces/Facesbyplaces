import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

Future<bool> apiRegularLogout() async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.delete(
    // Uri.http('http://fbp.dev1.koda.ws/alm_auth/sign_out', ''),
    Uri.http('fbp.dev1.koda.ws', '/alm_auth/sign_out',),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The status code of logout is ${response.statusCode}');

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

    sharedPrefs.remove('user-guest-session');

    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'profile',
        'email',
        'openid'
      ],
    );
    await googleSignIn.signOut();

    FacebookLogin fb = FacebookLogin();
    await fb.logOut();

    return true;
  }else{
    return false;
  }
}