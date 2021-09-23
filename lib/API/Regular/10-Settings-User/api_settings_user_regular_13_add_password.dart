import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiRegularAddPassword({required String newPassword}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();
  FormData formData = FormData();
  formData.files.addAll([
    MapEntry('password', MultipartFile.fromString(newPassword),),
    MapEntry('password_confirmation', MultipartFile.fromString(newPassword)),
  ]);

  var response = await dioRequest.put('http://facesbyplaces.com/alm_auth/password', data: formData,
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