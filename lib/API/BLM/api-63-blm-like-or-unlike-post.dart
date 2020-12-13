// http://fbp.dev1.koda.ws/api/v1/posts//likePost/unlikeOrLike

import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiBLMLikeOrUnlikePost({int postId, bool like}) async{

  bool result = false;

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  print('The access token is $getAccessToken');
  print('The UID is $getUID');
  print('The client is $getClient');


  try{
    var dioRequest = Dio();

    var formData;
    formData = FormData();
    formData.files.addAll([
      MapEntry('post_id', MultipartFile.fromString(postId.toString()),),
      MapEntry('like', MultipartFile.fromString(like.toString())),
    ]);

    var response = await dioRequest.post('http://fbp.dev1.koda.ws/api/v1/posts/likePost/unlikeOrLike', data: formData,
      options: Options(
        headers: <String, dynamic>{
          'access-token': getAccessToken,
          'uid': getUID,
          'client': getClient,
        }
      ),  
    );

    print('The status code for like or unlike is ${response.statusCode}');
    // print('The status body for update other details is ${response.data}');

    if(response.statusCode == 200){
      result = true;
    }
    
  }catch(e){
    print('The e is $e');
    result = false;
  }

  return result;
}