import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';

Future<int> apiRegularCreateMemorial({APIRegularCreateMemorial memorial}) async{
  
  int result = 0;
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  try{
    var dioRequest = dio.Dio();
    var formData = FormData();

    formData.files.addAll([
      MapEntry('memorial[name]', MultipartFile.fromString(memorial.almMemorialName,),),
      MapEntry('memorial[birthplace]', MultipartFile.fromString(memorial.almBirthPlace,),),
      MapEntry('memorial[dob]', MultipartFile.fromString(memorial.almDob,),),
      MapEntry('memorial[rip]', MultipartFile.fromString(memorial.almRip,),),
      MapEntry('memorial[cemetery]', MultipartFile.fromString(memorial.almCemetery)),
      MapEntry('memorial[country]', MultipartFile.fromString(memorial.almCountry,),),
      MapEntry('memorial[description]', MultipartFile.fromString(memorial.almDescription,),),
      MapEntry('relationship', MultipartFile.fromString(memorial.almRelationship,),),
    ]);

    if(memorial.almLatitude != null){
      MapEntry('memorial[latitude]', MultipartFile.fromString(memorial.almLatitude,),);
    }

    if(memorial.almLongitude != null){
      MapEntry('memorial[longitude]', MultipartFile.fromString(memorial.almLongitude,),);
    }

    if(memorial.almBackgroundImage != null || memorial.almBackgroundImage != ''){
      var file = await dio.MultipartFile.fromFile(memorial.almBackgroundImage.path, filename: memorial.almBackgroundImage.path);
      formData.files.add(MapEntry('memorial[backgroundImage]', file));
    }
    
    if(memorial.almProfileImage != null || memorial.almProfileImage != ''){
      print('profile image!');
      var file = await dio.MultipartFile.fromFile(memorial.almProfileImage.path, filename: memorial.almProfileImage.path);
      formData.files.add(MapEntry('memorial[profileImage]', file));
    }
    
    if(memorial.almImagesOrVideos != null || memorial.almImagesOrVideos != [''] || memorial.almImagesOrVideos != [null]){

      for(int i = 0; i < memorial.almImagesOrVideos.length; i++){
        if(memorial.almImagesOrVideos[i].path != null || memorial.almImagesOrVideos != ['']){
          var file = await dio.MultipartFile.fromFile(memorial.almImagesOrVideos[i].path, filename: memorial.almImagesOrVideos[i].path);
          formData.files.add(MapEntry('memorial[imagesOrVideos][]', file));
        }
      }
    }

    var response = await dioRequest.post('http://fbp.dev1.koda.ws/api/v1/pages/memorials', data: formData,
      options: Options(
        headers: <String, dynamic>{
          'access-token': getAccessToken,
          'uid': getUID,
          'client': getClient,
        }
      ),  
    );

    if(response.statusCode == 200){
      var value = response.data;
      var user = value['memorial'];
      int userId = user['id'];
      
      result = userId;
    }
  }catch(e){
    print('Error in create memorial: $e');
    result = 0;
  }

  return result;
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

  APIRegularCreateMemorial({
    this.almMemorialName, 
    this.almDescription, 
    this.almBirthPlace, 
    this.almDob, 
    this.almRip, 
    this.almCemetery,
    this.almCountry, 
    this.almRelationship, 
    this.almBackgroundImage, 
    this.almProfileImage, 
    this.almLatitude,
    this.almImagesOrVideos,
    this.almLongitude,
  });
}