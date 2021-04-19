import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<String> apiBLMAddMemorialAdmin({required String pageType, required int pageId, required int userId}) async{

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

  print('The access token is $getAccessToken');
  print('The uid is $getUID');
  print('The client is $getClient');

  print('The page type is $pageType');
  print('The page id is $pageId');
  print('The user id is $userId');

  Dio dioRequest = Dio();
  FormData formData = FormData();

  formData = FormData.fromMap({
    'page_type': pageType,
    'page_id': pageId,
    'user_id': userId,
    'account_type': '1'
  });

  var response = await dioRequest.post('http://fbp.dev1.koda.ws/api/v1/pageadmin', data: formData,
    options: Options(
      followRedirects: false,
      validateStatus: (status) {
        return status! < 600;
      },
      headers: <String, String>{
        'access-token': getAccessToken!,
        'uid': getUID!,
        'client': getClient!,
      }
    ),  
  );

  print('The status code of blm add admin is ${response.statusCode}');

  if(response.statusCode == 200){
    return 'Success';
  }else{
    var newData = Map<String, dynamic>.from(response.data);
    return newData['error'];
  }
}
