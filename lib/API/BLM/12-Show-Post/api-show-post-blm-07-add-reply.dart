import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';

Future<bool> apiBLMAddReply({int commentId, dynamic replyBody}) async{

  bool result = false;

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  try{

    var dioRequest = dio.Dio();
    var formData = FormData();

    formData = FormData.fromMap({
      'comment_id': commentId,
      'body': replyBody,
    });


    var response = await dioRequest.post('http://fbp.dev1.koda.ws/api/v1/posts/reply', data: formData,
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
    print('Error in show post - add reply: $e');
    result = false;
  }

  return result;
}