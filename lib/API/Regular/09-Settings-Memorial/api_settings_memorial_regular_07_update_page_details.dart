import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiRegularUpdatePageDetails({required String name, required String relationship, required String birthplace, required String dob, required String rip, required String country, required String cemetery, required int memorialId, required double latitude, required double longitude}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();
  FormData formData = FormData();
  
  formData.files.addAll([
    MapEntry('name', MultipartFile.fromString(name,),),
    MapEntry('birthplace', MultipartFile.fromString(birthplace,),),
    MapEntry('relationship', MultipartFile.fromString(relationship,),),
    // MapEntry('dob', MultipartFile.fromString(dob,),),
    // MapEntry('rip', MultipartFile.fromString(rip,),),
    MapEntry('dob', MultipartFile.fromString('Unknown',),),
    MapEntry('rip', MultipartFile.fromString('Unknown',),),
    MapEntry('country', MultipartFile.fromString(country,),),
    MapEntry('cemetery', MultipartFile.fromString(cemetery,),),
    MapEntry('latitude', MultipartFile.fromString('$latitude'),),
    MapEntry('longitude', MultipartFile.fromString('$longitude'),)
  ]);

  var response = await dioRequest.put('https://www.facesbyplaces.com/api/v1/pages/memorials/$memorialId', data: formData,
    options: Options(
      headers: <String, dynamic>{
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