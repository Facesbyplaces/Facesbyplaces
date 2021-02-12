import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiBLMUploadPhoto({dynamic image}) async{

  bool result = false;
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';
  int prefsUserID = sharedPrefs.getInt('blm-user-id');


  print('The access token is $getAccessToken');
  print('The uid is $getUID');
  print('The client is $getClient');

  print('The user id is $prefsUserID');
  print('The image is $image');

  try{

    var dioRequest = Dio();
    var formData;
    formData = FormData();

    formData = FormData.fromMap({
      'user_id': prefsUserID,
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

    if(response.statusCode == 200){
      result = true;
    }
  }catch(e){
    print('Error in upload photo: $e');
    result = false;
  }
  return result;
}