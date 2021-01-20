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

    var formData;
    formData = FormData();
    formData.files.addAll([
      MapEntry('memorial[name]', MultipartFile.fromString(memorial.memorialName,),),
      MapEntry('memorial[birthplace]', MultipartFile.fromString(memorial.birthPlace,),),
      MapEntry('memorial[dob]', MultipartFile.fromString(memorial.dob,),),
      MapEntry('memorial[rip]', MultipartFile.fromString(memorial.rip,),),
      MapEntry('memorial[cemetery]', MultipartFile.fromString(memorial.cemetery)),
      MapEntry('memorial[country]', MultipartFile.fromString(memorial.country,),),
      MapEntry('memorial[description]', MultipartFile.fromString(memorial.description,),),
      MapEntry('relationship', MultipartFile.fromString(memorial.relationship,),),
    ]);

    if(memorial.latitude != null){
      MapEntry('memorial[latitude]', MultipartFile.fromString(memorial.latitude,),);
    }

    if(memorial.longitude != null){
      MapEntry('memorial[longitude]', MultipartFile.fromString(memorial.longitude,),);
    }

    if(memorial.backgroundImage != null || memorial.backgroundImage != ''){
      var file = await dio.MultipartFile.fromFile(memorial.backgroundImage.path, filename: memorial.backgroundImage.path);
      formData.files.add(MapEntry('memorial[backgroundImage]', file));
    }
    
    if(memorial.profileImage != null || memorial.profileImage != ''){
      var file = await dio.MultipartFile.fromFile(memorial.profileImage.path, filename: memorial.profileImage.path);
      formData.files.add(MapEntry('memorial[profileImage]', file));
    }
    
    if(memorial.imagesOrVideos != null || memorial.imagesOrVideos != ['']){

      for(int i = 0; i < memorial.imagesOrVideos.length - 1; i++){
        if(memorial.imagesOrVideos[i].path != null || memorial.imagesOrVideos != ['']){
          var file = await dio.MultipartFile.fromFile(memorial.imagesOrVideos[i].path, filename: memorial.imagesOrVideos[i].path);
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
    print('The e in create memorial is $e');
    result = 0;
  }

  return result;
}

class APIRegularCreateMemorial{
  String memorialName;
  String description;
  String birthPlace;
  String dob;
  String rip;
  String cemetery;
  String country;
  String relationship;
  dynamic backgroundImage;
  dynamic profileImage;
  List<dynamic> imagesOrVideos;
  String latitude;
  String longitude;

  APIRegularCreateMemorial({
    this.memorialName, 
    this.description, 
    this.birthPlace, 
    this.dob, 
    this.rip, 
    this.cemetery,
    this.country, 
    this.relationship, 
    this.backgroundImage, 
    this.profileImage, 
    this.imagesOrVideos,
    this.latitude,
    this.longitude,
  });
}