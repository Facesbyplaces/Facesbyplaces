import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<String> apiRegularLeavePage({required int memorialId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';
  String result = 'Failed';

  // final sharedPrefs = await SharedPreferences.getInstance();
  // bool userSessionRegular = sharedPrefs.getBool('regular-user-session') ?? false;
  // bool userSessionBLM = sharedPrefs.getBool('blm-user-session') ?? false;
  // String? getAccessToken;
  // String? getUID;
  // String? getClient;
  // String result = 'Failed';

  // if(userSessionRegular == true){
  //   result = 'Memorial';
  //   getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  //   getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  //   getClient = sharedPrefs.getString('regular-client') ?? 'empty';
  // }else if(userSessionBLM == true){
  //   result = 'Blm';
  //   getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  //   getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  //   getClient = sharedPrefs.getString('blm-client') ?? 'empty';
  // }

  print('The access token is $getAccessToken');
  print('The uid is $getUID');
  print('The client is $getClient');

  Dio dioRequest = Dio();

  var response = await dioRequest.delete('http://fbp.dev1.koda.ws/api/v1/pages/memorials/$memorialId/relationship/leave',
    options: Options(
      followRedirects: false,
      validateStatus: (status) {
        return status! < 600;
      },
      headers: <String, dynamic>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),
  );

  print('The status code of regular leave page is ${response.statusCode}');
  print('The status data of regular leave page is ${response.data}');

  if(response.statusCode == 200){
    return result;
  }else{
    return 'Failed';
  }
}