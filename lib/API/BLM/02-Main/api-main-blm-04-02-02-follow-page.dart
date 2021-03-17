import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiBLMModifyFollowPage({required String pageType, required int pageId, required bool follow}) async{

  bool result = false;

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

  try{
    Dio dioRequest = Dio();

    var response = await dioRequest.put('http://fbp.dev1.koda.ws/api/v1/followers',
      options: Options(
        headers: <String, dynamic>{
          'Content-Type': 'application/json',
          'access-token': getAccessToken,
          'uid': getUID,
          'client': getClient,
        }
      ),  
    );

    print('The status code of follow page is ${response.statusCode}');

    if(response.statusCode == 200){
      result = true;
    }
    return result;
  }catch(e){
    print('The error is: $e');
    return result;
  }
}