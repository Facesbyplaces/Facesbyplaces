import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';

Future<bool> apiRegularUpdatePageImages({int memorialId, dynamic backgroundImage, dynamic profileImage}) async{

  bool result = false;
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  try{
    var dioRequest = Dio();
    final formData = FormData.fromMap({});

    if(backgroundImage != null){
      var file = await dio.MultipartFile.fromFile(backgroundImage.path, filename: backgroundImage.path);
      formData.files.add(MapEntry('backgroundImage', file));
    }
    
    if(profileImage != null){
      var file = await dio.MultipartFile.fromFile(profileImage.path, filename: profileImage.path);
      formData.files.add(MapEntry('profileImage', file));
    }

    var response = await dioRequest.put('http://fbp.dev1.koda.ws/api/v1/pages/memorials/$memorialId/images', data: formData,
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
    print('Error in update page image: $e');
    result = false;
  }
  return result;
}