import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiRegularHideAddress({required bool hide}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.put('http://fbp.dev1.koda.ws/api/v1/users/hideOrUnhideAddress?hide=$hide', 
    options: Options(
      headers: <String, dynamic>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  print('The status code of hide address is ${response.statusCode}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}