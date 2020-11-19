import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;

Future<bool> apiRegularCreateMemorial(APIRegularCreateMemorial memorial) async{
  bool result = false;
  final sharedPrefs = await SharedPreferences.getInstance();
  var getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  var getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  var getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  try{
    var dioRequest = dio.Dio();

    var formData;
    formData = FormData();
    formData.files.addAll([
      MapEntry('memorial[name]', MultipartFile.fromString(memorial.memorialName,),),
      MapEntry('memorial[birthplace]', MultipartFile.fromString(memorial.birthPlace,),),
      MapEntry('memorial[dob]', MultipartFile.fromString(memorial.dob,),),
      MapEntry('memorial[rip]', MultipartFile.fromString(memorial.rip,),),
      MapEntry('memorial[cemetery]', MultipartFile.fromString(memorial.cemetery,),),
      MapEntry('memorial[country]', MultipartFile.fromString(memorial.country,),),
      MapEntry('memorial[description]', MultipartFile.fromString(memorial.description,),),
      MapEntry('relationship', MultipartFile.fromString(memorial.relationship,),),
    ]);

    if(memorial.backgroundImage != null){
      var file = await dio.MultipartFile.fromFile(memorial.backgroundImage.path, filename: memorial.backgroundImage.path);
      formData.files.add(MapEntry('memorial[backgroundImage]', file));
    }
    
    if(memorial.profileImage != null){
      var file = await dio.MultipartFile.fromFile(memorial.profileImage.path, filename: memorial.profileImage.path);
      formData.files.add(MapEntry('memorial[profileImage]', file));
    }
    
    if(memorial.imagesOrVideos != null){
      var file = await dio.MultipartFile.fromFile(memorial.imagesOrVideos.path, filename: memorial.imagesOrVideos.path);
      formData.files.add(MapEntry('memorial[imagesOrVideos][]', file));
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

    print('The status code in regular memorial is ${response.statusCode}');
    print('The status data in regular memorial is ${response.data}');

    if(response.statusCode == 200){
      sharedPrefs.setString('regular-access-token', response.headers['access-token'].toString().replaceAll('[' ,'',).replaceAll(']', ''));
      sharedPrefs.setString('regular-uid', response.headers['uid'].toString().replaceAll('[' ,'',).replaceAll(']', ''));    
      sharedPrefs.setString('regular-client', response.headers['client'].toString().replaceAll('[' ,'',).replaceAll(']', ''));
      result = true;
    }
  }catch(e){
    print('The e is $e');
    result = false;
  }

  return result;
}

class APIRegularCreateMemorial{
  String memorialName;
  String birthPlace;
  String dob;
  String rip;
  String cemetery;
  String country;
  String description;
  String relationship;
  dynamic backgroundImage;
  dynamic profileImage;
  dynamic imagesOrVideos;
  
  APIRegularCreateMemorial({
    this.memorialName, 
    this.birthPlace, 
    this.dob, 
    this.rip, 
    this.cemetery, 
    this.country, 
    this.description, 
    this.relationship, 
    this.backgroundImage, 
    this.profileImage, 
    this.imagesOrVideos
  });
}