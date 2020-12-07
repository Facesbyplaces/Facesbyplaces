import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;

Future<int> apiBLMCreateMemorial(APIBLMCreateMemorial memorial) async{
  // bool result = false;
  int result = 0;
  final sharedPrefs = await SharedPreferences.getInstance();
  var getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  var getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  var getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  print('heheheh');

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

    if(memorial.latitude != null){
      MapEntry('blm[longitude]', MultipartFile.fromString(memorial.latitude,),);
    }

    if(memorial.longitude != null){
      MapEntry('blm[latitude]', MultipartFile.fromString(memorial.longitude,),);
    }

    if(memorial.backgroundImage != null){
      print('background image');
      print('The background image is ${memorial.backgroundImage}');
      var file = await dio.MultipartFile.fromFile(memorial.backgroundImage.path, filename: memorial.backgroundImage.path);
      formData.files.add(MapEntry('blm[backgroundImage]', file));
      print('finish backgroundImage');
    }
    
    if(memorial.profileImage != null){
      print('profile image');
      print('The background image is ${memorial.profileImage}');
      var file = await dio.MultipartFile.fromFile(memorial.profileImage.path, filename: memorial.profileImage.path);
      formData.files.add(MapEntry('blm[profileImage]', file));
      print('finish profileImage');
    }
    
    if(memorial.imagesOrVideos != null){
      print('images or videos');
      print('the length is');

      for(int i = 0; i < memorial.imagesOrVideos.length - 1; i++){
        if(memorial.imagesOrVideos[i].path != null){
          var file = await dio.MultipartFile.fromFile(memorial.imagesOrVideos[i].path, filename: memorial.imagesOrVideos[i].path);
          formData.files.add(MapEntry('blm[imagesOrVideos][]', file));
          print('The value images or videos is ${memorial.imagesOrVideos[i].path}');
        }
        print('heheheh');
      }

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

    if(response.statusCode == 200){
      var value = response.data;
      var user = value['blm'];
      int userId = user['id'];
      
      result = userId;
    }
  }catch(e){
    print('The error is $e');
    // result = false;
    result = 0;
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
  List<dynamic> imagesOrVideos;
  String latitude;
  String longitude;

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
    this.imagesOrVideos,
    this.latitude,
    this.longitude,
  });
}