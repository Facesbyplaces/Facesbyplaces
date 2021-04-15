import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiRegularDeleteMemorialAdmin({required String pageType, required int pageId, required int userId}) async{

  bool result = false;
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  try{
    Dio dioRequest = Dio();
    FormData formData = FormData();

    formData = FormData.fromMap({
      'page_type': pageType,
      'page_id': pageId,
      'user_id': userId,
    });

    var response = await dioRequest.delete('http://fbp.dev1.koda.ws/api/v1/pageadmin', data: formData,
      options: Options(
        headers: <String, String>{
          'access-token': getAccessToken,
          'uid': getUID,
          'client': getClient,
        }
      ),  
    );

    print('The status code of regular remove admin is ${response.statusCode}');

    if(response.statusCode == 200){
      result = true;
    }
  }catch(e){
    print('Error in remove admin: $e');
    result = false;
  }

  return result;
}
