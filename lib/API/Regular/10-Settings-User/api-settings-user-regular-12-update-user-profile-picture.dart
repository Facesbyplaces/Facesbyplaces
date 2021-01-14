// /users/image_upload/20

import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiRegularUpdateUserProfilePicture({dynamic image, int userId}) async{

  bool result = false;
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  print('The access token in user profile is $getAccessToken');
  print('The uid in user profile is $getUID');
  print('The client in user profile is $getClient');

  try{
    var dioRequest = Dio();
    var formData;
    formData = FormData();

    formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(image.path, filename: image.path),
    });

    var response = await dioRequest.put('http://fbp.dev1.koda.ws/api/v1/users/image_upload', data: formData,
      options: Options(
        headers: <String, String>{
          'access-token': getAccessToken,
          'uid': getUID,
          'client': getClient,
        }
      ),
    );

    print('The response status code in update upload photo is ${response.statusCode}');
    print('The response status data in update upload photo is ${response.data}');
    print('The headers in update upload photo is ${response.headers}');

    if(response.statusCode == 200){
      result = true;
      // if(response.headers['access-token'].toString().replaceAll('[', '').replaceAll(']', '') != null && response.headers['uid'].toString().replaceAll('[', '').replaceAll(']', '') != null && response.headers['client'].toString().replaceAll('[', '').replaceAll(']', '') != null){
      //   sharedPrefs.setString('regular-access-token', response.headers['access-token'].toString().replaceAll('[' ,'',).replaceAll(']', ''));
      //   sharedPrefs.setString('regular-uid', response.headers['uid'].toString().replaceAll('[' ,'',).replaceAll(']', ''));    
      //   sharedPrefs.setString('regular-client', response.headers['client'].toString().replaceAll('[' ,'',).replaceAll(']', ''));
      // }
    }
    
  }catch(e){
    print('The e is $e');
    result = false;
  }
  return result;
}