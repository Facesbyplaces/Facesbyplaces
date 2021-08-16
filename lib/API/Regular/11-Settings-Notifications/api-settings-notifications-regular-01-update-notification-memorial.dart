import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiRegularUpdateNotificationMemorial({required bool hide}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  // var response = await dioRequest.put('http://fbp.dev1.koda.ws/api/v1/notifications/newMemorial?setting=$hide',
  var response = await dioRequest.put('http://45.33.66.25:3001/api/v1/notifications/newMemorial?setting=$hide',
    options: Options(
      followRedirects: false,
      validateStatus: (status){
        return status! < 600;
      },
      headers: <String, dynamic>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  print('The status code of regular update notification memorial is ${response.statusCode}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}