import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiRegularUpdatePageImages({required int memorialId, required dynamic backgroundImage, required dynamic profileImage}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();
  FormData formData = FormData.fromMap({});

  print('The value of memorialId is $memorialId');
  print('The value of backgroundImage is ${backgroundImage.path}');
  print('The value of profileImage is ${profileImage.path}');

  if(backgroundImage.path != ''){
    var file = await MultipartFile.fromFile(backgroundImage.path, filename: backgroundImage.path);
    formData.files.add(MapEntry('backgroundImage', file));
  }
  
  if(profileImage.path != ''){
    var file = await MultipartFile.fromFile(profileImage.path, filename: profileImage.path);
    formData.files.add(MapEntry('profileImage', file));
  }

  // var response = await dioRequest.put('http://fbp.dev1.koda.ws/api/v1/pages/memorials/$memorialId/images', data: formData,
  var response = await dioRequest.put('http://45.33.66.25:3001/api/v1/pages/memorials/$memorialId/images', data: formData,
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

  print('The status code of regular update page image is ${response.statusCode}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}