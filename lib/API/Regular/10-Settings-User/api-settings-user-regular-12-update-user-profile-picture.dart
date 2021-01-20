import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiRegularUpdateUserProfilePicture({dynamic image, int userId}) async{

  bool result = false;
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

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

    if(response.statusCode == 200){
      result = true;
    }
    
  }catch(e){
    print('The e is $e');
    result = false;
  }
  return result;
}