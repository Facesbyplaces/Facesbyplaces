// ignore_for_file: file_names
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiRegularUploadPhoto({dynamic image}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';
  int prefsUserID = sharedPrefs.getInt('regular-user-id')!;
  
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

  print('The status code of regular upload photo is ${response.statusCode}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}