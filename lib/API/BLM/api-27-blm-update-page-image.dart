import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';

Future<bool> apiBLMUpdatePageImages(int memorialId, dynamic backgroundImage, dynamic profileImage) async{

  bool result = false;
  final sharedPrefs = await SharedPreferences.getInstance();
  var getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  var getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  var getClient = sharedPrefs.getString('blm-client') ?? 'empty';

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

    var response = await dioRequest.put('http://fbp.dev1.koda.ws/api/v1/pages/blm/$memorialId/images', data: formData,
      options: Options(
        headers: <String, String>{
          'access-token': getAccessToken,
          'uid': getUID,
          'client': getClient,
        }
      ),
    );

    print('The status code for updating image is ${response.statusCode}');

    if(response.statusCode == 200){
      sharedPrefs.setString('blm-access-token', response.headers['access-token'].toString().replaceAll('[' ,'',).replaceAll(']', ''));
      sharedPrefs.setString('blm-uid', response.headers['uid'].toString().replaceAll('[' ,'',).replaceAll(']', ''));    
      sharedPrefs.setString('blm-client', response.headers['client'].toString().replaceAll('[' ,'',).replaceAll(']', ''));
      sharedPrefs.setBool('blm-user-session', true);
      sharedPrefs.remove('blm-user-verify');
      result = true;
    }
  }catch(e){
    print('The e is $e');
    result = false;
  }
  return result;
}