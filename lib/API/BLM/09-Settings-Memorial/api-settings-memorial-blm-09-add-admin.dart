import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';

Future<bool> apiBLMAddMemorialAdmin({String pageType, int pageId, int userId}) async{

  bool result = false;
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  try{
    var dioRequest = dio.Dio();
    var formData = FormData();

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

    if(response.statusCode == 200){
      result = true;
    }
  }catch(e){
    print('Error in add memorial admin: $e');
    result = false;
  }

  return result;
}
