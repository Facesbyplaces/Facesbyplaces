import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiRegularDeleteComment({required int commentId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.delete('http://fbp.dev1.koda.ws/api/v1/posts/comment?comment_id=$commentId',
    options: Options(
      headers: <String, dynamic>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),
  );

  print('The page friends settings is ${response.statusCode}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }

  // final http.Response response = await http.delete(
  //   Uri.http('http://fbp.dev1.koda.ws/api/v1/posts/comment?comment_id=$commentId', ''),
  //   headers: <String, String>{
  //     'Content-Type': 'application/json',
  //     'access-token': getAccessToken,
  //     'uid': getUID,
  //     'client': getClient,
  //   },
  // );

  // if(response.statusCode == 200){
  //   return true;
  // }else{
  //   return false;
  // }
}