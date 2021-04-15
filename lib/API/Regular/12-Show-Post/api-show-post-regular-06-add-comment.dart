import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiRegularAddComment({required int postId, required dynamic commentBody}) async{

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
    FormData formData = FormData();

    formData = FormData.fromMap({
      'post_id': postId,
      'body': commentBody,
    });

    var response = await dioRequest.post('http://fbp.dev1.koda.ws/api/v1/posts/comment', data: formData,
      options: Options(
        headers: <String, String>{
          'access-token': getAccessToken!,
          'uid': getUID!,
          'client': getClient!,
        }
      ),  
    );

    print('The status code of regular add comment is ${response.statusCode}');

    if(response.statusCode == 200){
      result = true;
    }
  }catch(e){
    print('Error in show post - add comment: $e');
    result = false;
  }

  return result;
}