import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiRegularUploadPhoto(dynamic image) async{

  bool result = false;
  final sharedPrefs = await SharedPreferences.getInstance();
  int prefsUserID = sharedPrefs.getInt('regular-user-id');

  try{
    var dioRequest = Dio();
    final formData = FormData.fromMap({
      'user_id': prefsUserID,
      'image': await MultipartFile.fromFile(image.path, filename: image.path),
    });

    var response = await dioRequest.post('http://fbp.dev1.koda.ws/api/v1/users/image_upload', data: formData,);

    if(response.statusCode == 200){
      sharedPrefs.setString('regular-access-token', response.headers['access-token'].toString().replaceAll('[' ,'',).replaceAll(']', ''));
      sharedPrefs.setString('regular-uid', response.headers['uid'].toString().replaceAll('[' ,'',).replaceAll(']', ''));    
      sharedPrefs.setString('regular-client', response.headers['client'].toString().replaceAll('[' ,'',).replaceAll(']', ''));
      sharedPrefs.setBool('regular-user-session', true);
      sharedPrefs.remove('regular-user-verify');
      result = true;
    }
  }catch(e){
    print('The e is $e');
    result = false;
  }
  return result;
}