import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';

Future<bool> apiRegularLikeOrUnlikePost({int postId, bool like}) async{

  bool result = false;

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  try{

    var dioRequest = dio.Dio();
    var formData = FormData();

    formData = FormData.fromMap({
      'post_id': postId,
      'like': like,
    });

    var response = await dioRequest.put('http://fbp.dev1.koda.ws/api/v1/posts/likePost/unlikeOrLike', data: formData,
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
      //   sharedPrefs.setString('regular-access-token', response.headers['access-token'].toString().replaceAll('[' ,'',).replaceAll(']', ''));
      //   sharedPrefs.setString('regular-uid', response.headers['uid'].toString().replaceAll('[' ,'',).replaceAll(']', ''));    
      //   sharedPrefs.setString('regular-client', response.headers['client'].toString().replaceAll('[' ,'',).replaceAll(']', ''));
      // }
    }
  }catch(e){
    result = false;
  }

  return result;
}