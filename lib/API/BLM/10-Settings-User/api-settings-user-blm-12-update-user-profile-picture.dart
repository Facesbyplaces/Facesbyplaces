import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiBLMUpdateUserProfilePicture({required dynamic image, required int userId}) async{

  bool result = false;
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  try{
    var dioRequest = Dio();
    var formData = FormData();

    formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(image.path, filename: image.path),
    });

    var response = await dioRequest.put('http://fbp.dev1.koda.ws/api/v1/users/image_upload', data: formData,
      options: Options(
        headers: <String, String>{
          'access-token': getAccessToken,
          'uid': getUID,
          'client': getClient,
        }
      ),
    );

    print('The status code of blm update user profile picture is ${response.statusCode}');

    if(response.statusCode == 200){
      result = true;
    }
    
  }catch(e){
    print('Error in settings update user profile picture: $e');
    result = false;
  }
  return result;
}