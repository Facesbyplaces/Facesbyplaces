import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiBLMUploadPhoto({dynamic image}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';
  int prefsUserID = sharedPrefs.getInt('blm-user-id')!;

  Dio dioRequest = Dio();
  FormData formData = FormData();

  formData = FormData.fromMap({
    'user_id': prefsUserID,
    'image': await MultipartFile.fromFile(image.path, filename: image.path),
  });

  var response = await dioRequest.put('http://facesbyplaces.com/api/v1/users/image_upload', data: formData,
    options: Options(
      followRedirects: false,
      validateStatus: (status){
        return status! < 600;
      },
      headers: <String, String>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),
  );

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}