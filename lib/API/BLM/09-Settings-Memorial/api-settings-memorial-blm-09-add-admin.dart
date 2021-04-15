import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiBLMAddMemorialAdmin({required String pageType, required int pageId, required int userId}) async{

  bool result = false;
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  try{
    Dio dioRequest = Dio();
    FormData formData = FormData();

    formData = FormData.fromMap({
      'page_type': pageType,
      'page_id': pageId,
      'user_id': userId,
    });

    var response = await dioRequest.post('http://fbp.dev1.koda.ws/api/v1/pageadmin', data: formData,
      options: Options(
        headers: <String, String>{
          'access-token': getAccessToken,
          'uid': getUID,
          'client': getClient,
        }
      ),  
    );

    print('The status code of blm add admin is ${response.statusCode}');

    if(response.statusCode == 200){
      result = true;
    }
  }catch(e){
    print('Error in add memorial admin: $e');
    result = false;
  }

  return result;
}
