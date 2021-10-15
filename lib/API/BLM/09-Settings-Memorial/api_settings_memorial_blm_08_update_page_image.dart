import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiBLMUpdatePageImages({required int memorialId, required dynamic backgroundImage, required dynamic profileImage}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();
  FormData formData = FormData.fromMap({});

  if(backgroundImage.path != ''){
    var file = await MultipartFile.fromFile(backgroundImage.path, filename: backgroundImage.path);
    formData.files.add(MapEntry('backgroundImage', file));
  }
  
  if(profileImage.path != ''){
    var file = await MultipartFile.fromFile(profileImage.path, filename: profileImage.path);
    formData.files.add(MapEntry('profileImage', file));
  }

  var response = await dioRequest.put('https://facesbyplaces.com/api/v1/pages/blm/$memorialId/images', data: formData,
    options: Options(
      headers: <String, String>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      },
      validateStatus: (status){
        return status! < 600;
      },
      followRedirects: false,
    ),
  );

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}