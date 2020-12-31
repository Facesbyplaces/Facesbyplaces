import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';

Future<bool> apiBLMLikeOrUnlikePost({int postId, bool like}) async{

  bool result = false;
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  try{
    var dioRequest = dio.Dio();

    var formData;
    formData = FormData();

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

    print('The response status is ${response.statusCode}');
    print('The response data is ${response.data}');

    if(response.statusCode == 200){
      result = true;
    }
  }catch(e){
    print('The value of e is ${e.toString()}');
    result = false;
  }

  return result;
}