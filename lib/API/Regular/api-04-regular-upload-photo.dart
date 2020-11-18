import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;

Future<bool> apiRegularUploadPhoto(dynamic image) async{

  bool result = false;
  final sharedPrefs = await SharedPreferences.getInstance();
  int prefsUserID = sharedPrefs.getInt('regular-user-id');

  try{
    var dioRequest = dio.Dio();
    final formData = dio.FormData.fromMap({'user_id': prefsUserID});
    var file = await dio.MultipartFile.fromFile(image.path, filename: image.path);
    formData.files.add(MapEntry('image', file));

    var response = await dioRequest.post('http://chipin.dev1.koda.ws/api/v1/auth', data: formData);

    // print('The response in regular status is ${response.statusCode}');
    // print('The response in regular status is ${response.data}');

    if(response.statusCode == 200){
      sharedPrefs.setString('regular-access-token', response.headers['access-token'].toString().replaceAll('[' ,'',).replaceAll(']', ''));
      sharedPrefs.setString('regular-uid', response.headers['uid'].toString().replaceAll('[' ,'',).replaceAll(']', ''));    
      sharedPrefs.setString('regular-client', response.headers['client'].toString().replaceAll('[' ,'',).replaceAll(']', ''));
      sharedPrefs.setBool('regular-user-session', true);
      sharedPrefs.remove('regular-user-verify');
      result = true;
    }
  }catch(e){
    result = false;
  }
  return result;
}