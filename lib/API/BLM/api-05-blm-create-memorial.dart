import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;

Future<bool> apiBLMCreateMemorial(APIBLMCreateMemorial memorial) async{
  bool result = false;
  final sharedPrefs = await SharedPreferences.getInstance();
  var getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  var getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  var getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  try{
    var dioRequest = dio.Dio();

    var formData;
    formData = FormData();
    formData.files.addAll([
      MapEntry('blm[name]', MultipartFile.fromString(memorial.memorialName,),),
      MapEntry('blm[description]', MultipartFile.fromString(memorial.description,),),
      MapEntry('blm[location]', MultipartFile.fromString(memorial.locationOfIncident,),),
      MapEntry('blm[dob]', MultipartFile.fromString(memorial.dob,),),
      MapEntry('blm[rip]', MultipartFile.fromString(memorial.rip,),),
      MapEntry('blm[state]', MultipartFile.fromString(memorial.state,),),
      MapEntry('blm[country]', MultipartFile.fromString(memorial.country,),),
      MapEntry('blm[precinct]', MultipartFile.fromString(memorial.precinct,),),
      MapEntry('relationship', MultipartFile.fromString(memorial.relationship,),),
    ]);

    if(memorial.backgroundImage != null){
      var file = await dio.MultipartFile.fromFile(memorial.backgroundImage.path, filename: memorial.backgroundImage.path);
      formData.files.add(MapEntry('blm[backgroundImage]', file));
    }
    
    if(memorial.profileImage != null){
      var file = await dio.MultipartFile.fromFile(memorial.profileImage.path, filename: memorial.profileImage.path);
      formData.files.add(MapEntry('blm[profileImage]', file));
    }
    
    if(memorial.imagesOrVideos != null){
      var file = await dio.MultipartFile.fromFile(memorial.imagesOrVideos.path, filename: memorial.imagesOrVideos.path);
      formData.files.add(MapEntry('blm[imagesOrVideos][]', file));
    }

    var response = await dioRequest.post('http://fbp.dev1.koda.ws/api/v1/pages/blm', data: formData,
      options: Options(
        headers: <String, dynamic>{
          'access-token': getAccessToken,
          'uid': getUID,
          'client': getClient,
        }
      ),  
    );

    // print('The status code in blm memorial is ${response.statusCode}');
    // print('The status data in blm memorial is ${response.data}');

    if(response.statusCode == 200){
      // sharedPrefs.setString('blm-access-token', response.headers['access-token'].toString().replaceAll('[' ,'',).replaceAll(']', ''));
      // sharedPrefs.setString('blm-uid', response.headers['uid'].toString().replaceAll('[' ,'',).replaceAll(']', ''));    
      // sharedPrefs.setString('blm-client', response.headers['client'].toString().replaceAll('[' ,'',).replaceAll(']', ''));
      result = true;
    }
  }catch(e){
    print('The error is $e');
    result = false;
  }

  return result;
}

class APIBLMCreateMemorial{
  String memorialName;
  String description;
  String locationOfIncident;
  String dob;
  String rip;
  String state;
  String country;
  String precinct;
  String relationship;
  dynamic backgroundImage;
  dynamic profileImage;
  dynamic imagesOrVideos;

  APIBLMCreateMemorial({
    this.memorialName, 
    this.description, 
    this.locationOfIncident, 
    this.dob, 
    this.rip, 
    this.state, 
    this.country, 
    this.precinct, 
    this.relationship, 
    this.backgroundImage, 
    this.profileImage, 
    this.imagesOrVideos
  });
}