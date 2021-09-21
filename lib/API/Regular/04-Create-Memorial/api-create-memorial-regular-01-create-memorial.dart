// ignore_for_file: file_names
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<int> apiRegularCreateMemorial({required APIRegularCreateMemorial memorial}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();
  FormData formData = FormData();

  formData.files.addAll([
    MapEntry('memorial[name]', MultipartFile.fromString(memorial.almMemorialName,),),
    MapEntry('memorial[birthplace]', MultipartFile.fromString(memorial.almBirthPlace,),),
    MapEntry('memorial[dob]', MultipartFile.fromString(memorial.almDob,),),
    MapEntry('memorial[rip]', MultipartFile.fromString(memorial.almRip,),),
    MapEntry('memorial[cemetery]', MultipartFile.fromString(memorial.almCemetery)),
    MapEntry('memorial[country]', MultipartFile.fromString(memorial.almCountry,),),
    MapEntry('memorial[description]', MultipartFile.fromString(memorial.almDescription,),),
    MapEntry('relationship', MultipartFile.fromString(memorial.almRelationship,),),
    MapEntry('memorial[latitude]', MultipartFile.fromString(memorial.almLatitude,),),
    MapEntry('memorial[longitude]', MultipartFile.fromString(memorial.almLongitude,),)
  ]);

  if(memorial.almBackgroundImage != null || memorial.almBackgroundImage != ''){
    var file = await MultipartFile.fromFile(memorial.almBackgroundImage.path, filename: memorial.almBackgroundImage.path);
    formData.files.add(MapEntry('memorial[backgroundImage]', file));
  }
  
  if(memorial.almProfileImage != null || memorial.almProfileImage != ''){
    var file = await MultipartFile.fromFile(memorial.almProfileImage.path, filename: memorial.almProfileImage.path);
    formData.files.add(MapEntry('memorial[profileImage]', file));
  }
  
  if(memorial.almImagesOrVideos != [''] || memorial.almImagesOrVideos != [null]){
    for(int i = 0; i < memorial.almImagesOrVideos.length; i++){
      if(memorial.almImagesOrVideos[i].path != null || memorial.almImagesOrVideos != ['']){
        var file = await MultipartFile.fromFile(memorial.almImagesOrVideos[i].path, filename: memorial.almImagesOrVideos[i].path);
        formData.files.add(MapEntry('memorial[imagesOrVideos][]', file));
      }
    }
  }

  var response = await dioRequest.post('http://facesbyplaces.com/api/v1/pages/memorials', data: formData,
    options: Options(
      followRedirects: false,
      validateStatus: (status){
        return status! < 600;
      },
      headers: <String, dynamic>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  if(response.statusCode == 200){
    var value = response.data;
    int userId = value['alm']['memorial']['id'];
    
    return userId;
  }else{
    return 0;
  }
}

class APIRegularCreateMemorial{
  String almMemorialName;
  String almDescription;
  String almBirthPlace;
  String almDob;
  String almRip;
  String almCemetery;
  String almCountry;
  String almRelationship;
  dynamic almBackgroundImage;
  dynamic almProfileImage;
  List<dynamic> almImagesOrVideos;
  String almLatitude;
  String almLongitude;
  APIRegularCreateMemorial({required this.almMemorialName, required this.almDescription, required this.almBirthPlace, required this.almDob, required this.almRip, required this.almCemetery,required this.almCountry, required this.almRelationship, required this.almBackgroundImage, required this.almProfileImage, required this.almLatitude,required this.almImagesOrVideos, required this.almLongitude,});
}