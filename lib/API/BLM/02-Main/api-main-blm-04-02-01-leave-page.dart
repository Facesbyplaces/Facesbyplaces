// ignore_for_file: file_names
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<String> apiBLMLeavePage({required int memorialId}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';
  String result = 'Failed';

  Dio dioRequest = Dio();

  var response = await dioRequest.delete('http://facesbyplaces.com/api/v1/pages/blm/$memorialId/relationship/leave',
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

  print('The status code of blm leave page is ${response.statusCode}');

  if(response.statusCode == 200){
    return result;
  }else{
    return 'Failed';
  }
}