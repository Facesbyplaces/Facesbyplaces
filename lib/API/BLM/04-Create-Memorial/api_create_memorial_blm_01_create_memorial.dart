import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<int> apiBLMCreateMemorial({required APIBLMCreateMemorial blmMemorial}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();
  FormData formData = FormData();

  formData.files.addAll([
    MapEntry('blm[name]', MultipartFile.fromString(blmMemorial.blmMemorialName,),),
    MapEntry('blm[description]', MultipartFile.fromString(blmMemorial.blmDescription,),),
    MapEntry('blm[location]', MultipartFile.fromString(blmMemorial.blmLocationOfIncident,),),
    MapEntry('blm[rip]', MultipartFile.fromString(blmMemorial.blmRip,),),
    MapEntry('blm[state]', MultipartFile.fromString(blmMemorial.blmState,),),
    MapEntry('blm[country]', MultipartFile.fromString(blmMemorial.blmCountry,),),
    MapEntry('relationship', MultipartFile.fromString(blmMemorial.blmRelationship,),),
    MapEntry('blm[latitude]', MultipartFile.fromString(blmMemorial.blmLatitude,),),
    MapEntry('blm[longitude]', MultipartFile.fromString(blmMemorial.blmLongitude,),),
  ]);

  if(blmMemorial.blmBackgroundImage != null || blmMemorial.blmBackgroundImage != ''){
    var file = await MultipartFile.fromFile(blmMemorial.blmBackgroundImage.path, filename: blmMemorial.blmBackgroundImage.path);
    formData.files.add(MapEntry('blm[backgroundImage]', file));
  }
  
  if(blmMemorial.blmProfileImage != null || blmMemorial.blmProfileImage != ''){
    var file = await MultipartFile.fromFile(blmMemorial.blmProfileImage.path, filename: blmMemorial.blmProfileImage.path);
    formData.files.add(MapEntry('blm[profileImage]', file));
  }
  
  if(blmMemorial.blmImagesOrVideos != []){
    for(int i = 0; i < blmMemorial.blmImagesOrVideos.length; i++){
      if(blmMemorial.blmImagesOrVideos[i].path != null || blmMemorial.blmImagesOrVideos != ['']){
        var file = await MultipartFile.fromFile(blmMemorial.blmImagesOrVideos[i].path, filename: blmMemorial.blmImagesOrVideos[i].path);
        formData.files.add(MapEntry('blm[imagesOrVideos][]', file));
      }
    }
  }

  // var response = await dioRequest.post('https://facesbyplaces.com/api/v1/pages/blm', data: formData,
  var response = await dioRequest.post('https://www.facesbyplaces.com/api/v1/pages/blm', data: formData,
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
    var value = response.data;
    int userId = value['blm']['memorial']['id'];
    
    return userId;
  }else{
    return 0;
  }
}

class APIBLMCreateMemorial{
  String blmMemorialName;
  String blmDescription;
  String blmLocationOfIncident;
  String blmRip;
  String blmState;
  String blmCountry;
  String blmRelationship;
  dynamic blmBackgroundImage;
  dynamic blmProfileImage;
  List<dynamic> blmImagesOrVideos;
  String blmLatitude;
  String blmLongitude;
  APIBLMCreateMemorial({required this.blmMemorialName, required this.blmDescription, required this.blmLocationOfIncident, required this.blmRip, required this.blmState, required this.blmCountry, required this.blmRelationship, required this.blmBackgroundImage, required this.blmProfileImage, required this.blmImagesOrVideos, required this.blmLatitude, required this.blmLongitude,});
}