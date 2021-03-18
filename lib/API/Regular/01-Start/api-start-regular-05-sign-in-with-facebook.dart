import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiRegularSignInWithFacebook({required String firstName, required String lastName, required String email, required String username, required String facebookId, required String image}) async{

  bool result = false;

  try{
    Dio dioRequest = Dio();

    var response = await dioRequest.post('http://fbp.dev1.koda.ws/alm_auth/sign_in?account_type=2&first_name=$firstName&last_name=$lastName&email=$email&username=$username&facebook_id=$facebookId&image=$image',
      options: Options(
        headers: <String, dynamic>{
          'Content-Type': 'application/json',
        }
      ),  
    );

    print('The status code of login with facebook is ${response.statusCode}');

    if(response.statusCode == 200){
      var newData = Map<String, dynamic>.from(response.data);
      var user = newData['user'];
      int userId = user['id'];

      final sharedPrefs = await SharedPreferences.getInstance();

      sharedPrefs.setInt('regular-user-id', userId);
      sharedPrefs.setString('regular-access-token', response.headers['access-token'].toString().replaceAll(']', '').replaceAll('[', ''));
      sharedPrefs.setString('regular-uid', response.headers['uid'].toString().replaceAll(']', '').replaceAll('[', ''));
      sharedPrefs.setString('regular-client', response.headers['client'].toString().replaceAll(']', '').replaceAll('[', ''));
      sharedPrefs.setBool('regular-user-session', true);
      sharedPrefs.setBool('user-guest-session', false);

      result = true;
    }
    return result;
  }catch(e){
    print('The error of login with facebook is: $e');
    return result;
  }
}

  // final http.Response response = await http.post(
  //   Uri.http('http://fbp.dev1.koda.ws/alm_auth/sign_in?account_type=2&first_name=$firstName&last_name=$lastName&email=$email&username=$username&facebook_id=$facebookId&image=$image', ''),
  //   headers: <String, String>{
  //     'Content-Type': 'application/json',
  //   }
  // );

  // if(response.statusCode == 200){
  //   var value = json.decode(response.body);
  //   int userId = value['id'];
  //   final sharedPrefs = await SharedPreferences.getInstance();

  //   sharedPrefs.setInt('regular-user-id', userId);
  //   sharedPrefs.setString('regular-access-token', response.headers['access-token']!);
  //   sharedPrefs.setString('regular-uid', response.headers['uid']!);
  //   sharedPrefs.setString('regular-client', response.headers['client']!);
  //   sharedPrefs.setBool('regular-user-session', true);
  //   sharedPrefs.setBool('user-guest-session', false);

  //   return true;
  // }else{
  //   return false;
  // }