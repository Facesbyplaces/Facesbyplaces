import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<String> apiRegularDeleteMemorialAdmin({required String pageType, required int pageId, required int userId}) async{
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
  FormData formData = FormData();

  formData = FormData.fromMap({
    'page_type': pageType,
    'page_id': pageId,
    'user_id': userId,
  });

  var response = await dioRequest.delete('http://45.33.66.25:3001/api/v1/pageadmin', data: formData,
    options: Options(
      followRedirects: false,
      validateStatus: (status){
        return status! < 600;
      },
      headers: <String, String>{
        'access-token': getAccessToken!,
        'uid': getUID!,
        'client': getClient!,
      }
    ),  
  );

  print('The status code of regular remove admin is ${response.statusCode}');

  if(response.statusCode == 200){
    return 'Success';
  }else{
    var newData = Map<String, dynamic>.from(response.data);
    return newData['error'];
  }
}