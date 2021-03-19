import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiBLMUpdatePageImages({required int memorialId, required dynamic backgroundImage, required dynamic profileImage}) async{

  bool result = false;
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  try{
    Dio dioRequest = Dio();
    FormData formData = FormData.fromMap({});

    if(backgroundImage != null){
      var file = await MultipartFile.fromFile(backgroundImage.path, filename: backgroundImage.path);
      formData.files.add(MapEntry('backgroundImage', file));
    }
    
    if(profileImage != null){
      var file = await MultipartFile.fromFile(profileImage.path, filename: profileImage.path);
      formData.files.add(MapEntry('profileImage', file));
    }

    var response = await dioRequest.put('http://fbp.dev1.koda.ws/api/v1/pages/blm/$memorialId/images', data: formData,
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
    print('Error in page update page image: $e');
    result = false;
  }
  return result;
}