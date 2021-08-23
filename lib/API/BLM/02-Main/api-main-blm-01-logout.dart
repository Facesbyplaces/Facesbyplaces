import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart';

Future<bool> apiBLMLogout() async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  // var response = await dioRequest.delete('http://45.33.66.25:3001/auth/sign_out',
  var response = await dioRequest.delete('http://facesbyplaces.com/auth/sign_out',
    options: Options(
      followRedirects: false,
      validateStatus: (status){
        return status! < 600;
      },
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  print('The status code of blm logout is ${response.statusCode}');

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

    GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['profile', 'email', 'openid'],);
    
    bool isGoogleSignedIn = await googleSignIn.isSignedIn();
    if(isGoogleSignedIn == true){
      await googleSignIn.signOut();
    }

    FacebookLogin fb = FacebookLogin();
    bool isFacebookSignedIn = await fb.isLoggedIn;
    
    if(isFacebookSignedIn == true){
      await fb.logOut();
    }

    return true;
  }else{
    return false;
  }
}