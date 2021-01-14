import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiRegularUploadPhoto({dynamic image}) async{

  bool result = false;
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';
  int prefsUserID = sharedPrefs.getInt('regular-user-id');

  print('The user id is $prefsUserID');
  print('The image is ${image.path}');

  print('The access token is $getAccessToken');
  print('The access token is $getUID');
  print('The access token is $getClient');

  try{
    var dioRequest = Dio();
    var formData;
    formData = FormData();

    formData = FormData.fromMap({
      // 'user_id': prefsUserID,
      'image': await MultipartFile.fromFile(image.path, filename: image.path),
    });

    

    // var response = await dioRequest.put('http://fbp.dev1.koda.ws/api/v1/users/image_upload/:id', data: formData,
    var response = await dioRequest.put('http://fbp.dev1.koda.ws/api/v1/users/image_upload', data: formData,
      options: Options(
        headers: <String, String>{
          'access-token': getAccessToken,
          'uid': getUID,
          'client': getClient,
        }
      ),
    );

    print('The response status code in upload photo is ${response.statusCode}');
    print('The response status data in upload photo is ${response.data}');

    if(response.statusCode == 200){
      sharedPrefs.setString('regular-access-token', response.headers['access-token'].toString().replaceAll('[' ,'',).replaceAll(']', ''));
      sharedPrefs.setString('regular-uid', response.headers['uid'].toString().replaceAll('[' ,'',).replaceAll(']', ''));    
      sharedPrefs.setString('regular-client', response.headers['client'].toString().replaceAll('[' ,'',).replaceAll(']', ''));
      sharedPrefs.setBool('regular-user-session', true);
      // sharedPrefs.remove('regular-user-verify');
      result = true;
    }
    
  }catch(e){
    print('The e is $e');
    result = false;
  }
  return result;
}