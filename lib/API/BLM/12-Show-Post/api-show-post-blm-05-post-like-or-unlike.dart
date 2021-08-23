import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiBLMLikeOrUnlikePost({required int postId, required bool like}) async{
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

  print('The access token is $getAccessToken');
  print('The uid is $getUID');
  print('The client is $getClient');
  print('The post id is $postId');

  Dio dioRequest = Dio();
  FormData formData = FormData();

  formData = FormData.fromMap({
    'post_id': postId,
    'like': like,
  });

  // var response = await dioRequest.put('http://45.33.66.25:3001/api/v1/posts/likePost/unlikeOrLike', data: formData,
  var response = await dioRequest.put('http://facesbyplaces.com/api/v1/posts/likePost/unlikeOrLike', data: formData,
    options: Options(
      followRedirects: false,
      validateStatus: (status){
        return status! < 600;
      },
      headers: <String, String>{
        'access-token': getAccessToken!,
        'uid': getUID!,
        'client': getClient!,
      }
    ),  
  );

  print('The status code of blm post like or unlike is ${response.statusCode}');
  print('The status data of blm post like or unlike is ${response.data}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}