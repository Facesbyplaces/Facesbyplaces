import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiBLMUploadPhoto({dynamic image}) async{

  bool result = false;
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';
  int prefsUserID = sharedPrefs.getInt('regular-user-id');

  try{
    // var dioRequest = Dio();
    // final formData = FormData.fromMap({
    //   'image': await MultipartFile.fromFile(image.path, filename: image.path),
    // });

    // var response = await dioRequest.put('http://fbp.dev1.koda.ws/api/v1/users/image_upload/:id', data: formData,
    //   options: Options(
    //     headers: <String, String>{
    //       'access-token': getAccessToken,
    //       'uid': getUID,
    //       'client': getClient,
    //     }
    //   ),
    // );

    var dioRequest = Dio();
    var formData;
    formData = FormData();

    formData = FormData.fromMap({
      'user_id': prefsUserID,
      'image': await MultipartFile.fromFile(image.path, filename: image.path),
    });

    

    // var response = await dioRequest.put('http://fbp.dev1.koda.ws/api/v1/users/image_upload/:id', data: formData,
    var response = await dioRequest.post('http://fbp.dev1.koda.ws/api/v1/users/image_upload', data: formData,
      options: Options(
        headers: <String, String>{
          'access-token': getAccessToken,
          'uid': getUID,
          'client': getClient,
        }
      ),
    );

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