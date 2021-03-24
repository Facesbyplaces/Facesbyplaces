import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiRegularModifyFollowPage({required String pageType, required int pageId, required bool follow}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  bool userSessionRegular = sharedPrefs.getBool('regular-user-session') ?? false;
  bool userSessionBLM = sharedPrefs.getBool('blm-user-session') ?? false;
  String? getAccessToken;
  String? getUID;
  String? getClient;

  if(userSessionRegular == true){
    getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
    getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
    getClient = sharedPrefs.getString('regular-client') ?? 'empty';
  }else if(userSessionBLM == true){
    getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
    getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
    getClient = sharedPrefs.getString('blm-client') ?? 'empty';
  }

  Dio dioRequest = Dio();

  var response = await dioRequest.put('http://fbp.dev1.koda.ws/api/v1/followers',
    options: Options(
      headers: <String, dynamic>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),
    queryParameters: <String, dynamic>{
      'page_type': '$pageType',
      'page_id': '$pageId',
      'follow': '$follow',
    }
  );

  print('The status code of follow page ${response.statusCode}');

  if(response.statusCode == 200){
    return true;
  }else{
    print('Error occurred of follow page ${response.statusMessage}');
    return false;
  }
}