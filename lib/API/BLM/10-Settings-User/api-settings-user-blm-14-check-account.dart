import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiBLMCheckAccount({required String email}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  // var response = await dioRequest.get('http://45.33.66.25:3001/api/v1/users/check_password?account_type=1&email=$email',
  var response = await dioRequest.get('http://facesbyplaces.com/api/v1/users/check_password?account_type=1&email=$email',
    options: Options(
      followRedirects: false,
      validateStatus: (status){
        return status! < 600;
      },
      headers: <String, String>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  print('The status code of blm check account is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    bool passwordUpdated = newData['password_updated'];

    return passwordUpdated;
  }else{
    throw Exception('Something went wrong. Please try again.');
  }
}