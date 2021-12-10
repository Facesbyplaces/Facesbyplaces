import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

// Future<bool> apiBLMUpdatePageDetails({required int memorialId, required String name, required String description, required String relationship, required String location, required String dob, required String rip, required String state, required String country, required String precinct}) async{
// Future<bool> apiBLMUpdatePageDetails({required int memorialId, required String name, required String description, required String relationship, required String location, required String dob, required String rip, required String state, required String country,}) async{
  Future<bool> apiBLMUpdatePageDetails({required int memorialId, required String name, required String description, required String relationship, required String location, required String rip, required String state, required String country, required double latitude, required double longitude}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();
  FormData formData = FormData();
  
  formData.files.addAll([
    MapEntry('name', MultipartFile.fromString(name,),),
    MapEntry('description', MultipartFile.fromString(description,),),
    MapEntry('relationship', MultipartFile.fromString(relationship,),),
    MapEntry('location', MultipartFile.fromString(location,),),
    // MapEntry('dob', MultipartFile.fromString(dob,),),
    MapEntry('rip', MultipartFile.fromString(rip,),),
    MapEntry('state', MultipartFile.fromString(state,),),
    MapEntry('country', MultipartFile.fromString(country,),),
    // MapEntry('precinct', MultipartFile.fromString(precinct,),),
    MapEntry('latitude', MultipartFile.fromString('$latitude'),),
    MapEntry('longitude', MultipartFile.fromString('$longitude'),)
  ]);

  var response = await dioRequest.put('https://www.facesbyplaces.com/api/v1/pages/blm/$memorialId', data: formData,
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