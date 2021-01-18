import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';

Future<bool> apiBLMAddComment({int postId, dynamic commentBody}) async{

  bool result = false;

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  try{
    var dioRequest = dio.Dio();
    var formData = FormData();

    formData = FormData.fromMap({
      'post_id': postId,
      'body': commentBody,
    });


    var response = await dioRequest.post('http://fbp.dev1.koda.ws/api/v1/posts/comment', data: formData,
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
      // if(response.headers['access-token'].toString().replaceAll('[', '').replaceAll(']', '') != null && response.headers['uid'].toString().replaceAll('[', '').replaceAll(']', '') != null && response.headers['client'].toString().replaceAll('[', '').replaceAll(']', '') != null){
      //   sharedPrefs.setString('blm-access-token', response.headers['access-token'].toString().replaceAll('[' ,'',).replaceAll(']', ''));
      //   sharedPrefs.setString('blm-uid', response.headers['uid'].toString().replaceAll('[' ,'',).replaceAll(']', ''));    
      //   sharedPrefs.setString('blm-client', response.headers['client'].toString().replaceAll('[' ,'',).replaceAll(']', ''));
      // }
    }
  }catch(e){
    result = false;
  }

  return result;
}