import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<String> apiRegularLeavePage({required int memorialId}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';
  String result = 'Failed';

  Dio dioRequest = Dio();

  // var response = await dioRequest.delete('http://45.33.66.25:3001/api/v1/pages/memorials/$memorialId/relationship/leave',
  var response = await dioRequest.delete('http://facesbyplaces.com/api/v1/pages/memorials/$memorialId/relationship/leave',
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

  if(response.statusCode == 200){
    return result;
  }else{
    return 'Failed';
  }
}