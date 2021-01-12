import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';

Future<bool> apiRegularAddMemorialAdmin({String pageType, int pageId, int userId}) async{

  bool result = false;
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

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
      if(response.headers['access-token'].toString().replaceAll('[', '').replaceAll(']', '') != null && response.headers['uid'].toString().replaceAll('[', '').replaceAll(']', '') != null && response.headers['client'].toString().replaceAll('[', '').replaceAll(']', '') != null){
        sharedPrefs.setString('regular-access-token', response.headers['access-token'].toString().replaceAll('[' ,'',).replaceAll(']', ''));
        sharedPrefs.setString('regular-uid', response.headers['uid'].toString().replaceAll('[' ,'',).replaceAll(']', ''));    
        sharedPrefs.setString('regular-client', response.headers['client'].toString().replaceAll('[' ,'',).replaceAll(']', ''));
      }
      result = true;
    }
  }catch(e){
    result = false;
  }

  return result;
}
