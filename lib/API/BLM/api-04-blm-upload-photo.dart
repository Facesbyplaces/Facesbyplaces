import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;

Future<bool> apiBLMUploadPhoto(dynamic image) async{

  bool result = false;
  final sharedPrefs = await SharedPreferences.getInstance();
  int prefsUserID = sharedPrefs.getInt('blm-user-id');

  try{
    var dioRequest = dio.Dio();
    final formData = dio.FormData.fromMap({'user_id': prefsUserID});
    var file = await dio.MultipartFile.fromFile(image.path, filename: image.path);
    formData.files.add(MapEntry('image', file));

    var response = await dioRequest.post('http://chipin.dev1.koda.ws/api/v1/auth', data: formData);

    if(response.statusCode == 200){
      sharedPrefs.setString('blm-access-token', response.headers['access-token'].toString().replaceAll('[' ,'',).replaceAll(']', ''));
      sharedPrefs.setString('blm-uid', response.headers['uid'].toString().replaceAll('[' ,'',).replaceAll(']', ''));    
      sharedPrefs.setString('blm-client', response.headers['client'].toString().replaceAll('[' ,'',).replaceAll(']', ''));
      sharedPrefs.setBool('blm-user-session', true);
      sharedPrefs.remove('blm-user-verify');
      result = true;
    }
  }catch(e){
    result = false;
  }
  return result;
}