import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<String> apiRegularLeavePage({required int memorialId}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';
  // String result = 'Failed';
  String result = 'Success';

  Dio dioRequest = Dio();

  var response = await dioRequest.delete('https://www.facesbyplaces.com/api/v1/pages/memorials/$memorialId/relationship/leave',
    options: Options(
      headers: <String, dynamic>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      },
      validateStatus: (status){
        return status! < 600;
      },
      followRedirects: false,
    ),
  );

  if(response.statusCode == 200){
    return result;
  }else{
    // return 'Failed';
    var newData = Map<String, dynamic>.from(response.data);
    return newData['message'];
  }
}