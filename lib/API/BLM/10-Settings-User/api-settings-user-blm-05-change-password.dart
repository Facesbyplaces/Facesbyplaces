import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiBLMChangePassword({required String currentPassword, required String newPassword}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();
  FormData formData = FormData();

  formData.files.addAll([
    MapEntry('current_password', MultipartFile.fromString(currentPassword),),
    MapEntry('new_password', MultipartFile.fromString(newPassword)),
  ]);

  var response = await dioRequest.post('http://fbp.dev1.koda.ws/api/v1/users/changePassword', data: formData,
    options: Options(
      followRedirects: false,
      validateStatus: (status) {
        return status! < 600;
      },
      headers: <String, dynamic>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  print('The status code of blm change password is ${response.statusCode}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}