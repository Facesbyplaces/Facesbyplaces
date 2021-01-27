import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiRegularChangePassword({String currentPassword, String newPassword}) async{

  bool result = false;

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  try{
    
    var dioRequest = Dio();
    var formData = FormData();

    formData.files.addAll([
      MapEntry('current_password', MultipartFile.fromString(currentPassword),),
      MapEntry('new_password', MultipartFile.fromString(newPassword)),
    ]);

    var response = await dioRequest.post('http://fbp.dev1.koda.ws/api/v1/users/changePassword', data: formData,
      options: Options(
        headers: <String, dynamic>{
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
    result = false;
  }

  return result;
}