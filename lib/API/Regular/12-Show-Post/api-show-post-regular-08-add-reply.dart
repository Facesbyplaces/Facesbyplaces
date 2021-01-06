import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';

Future<bool> apiRegularAddReply({int commentId, dynamic replyBody}) async{

  bool result = false;
  final sharedPrefs = await SharedPreferences.getInstance();
  var getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  var getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  var getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  try{
    var dioRequest = dio.Dio();

    var formData;
    formData = FormData();

    formData = FormData.fromMap({
      'comment_id': commentId,
      'body': replyBody,
    });


    // var response = await dioRequest.post('http://fbp.dev1.koda.ws/api/v1/posts/comment', data: formData,
    // http://fbp.dev1.koda.ws/api/v1/posts/reply
    var response = await dioRequest.post('http://fbp.dev1.koda.ws/api/v1/posts/reply', data: formData,
      options: Options(
        headers: <String, String>{
          'access-token': getAccessToken,
          'uid': getUID,
          'client': getClient,
        }
      ),  
    );

    // print('The response status for reply is ${response.statusCode}');
    // print('The response data for reply is ${response.data}');

    if(response.statusCode == 200){
      result = true;
    }
  }catch(e){
    print('The value of e is ${e.toString()}');
    result = false;
  }

  return result;
}