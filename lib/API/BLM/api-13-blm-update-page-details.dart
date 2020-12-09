import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiBLMUpdatePageDetails({int memorialId, String name, String description, String relationship, String location, String dob, String rip, String state, String country, String precinct}) async{

  bool result = false;

  final sharedPrefs = await SharedPreferences.getInstance();
  // int memorialId = sharedPrefs.getInt('blm-user-memorial-id') ?? 0;
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  // print('The memorialId is $memorialId');
  print('The getAccessToken is $getAccessToken');
  print('The getUID is $getUID');
  print('The getClient is $getClient');

  try{
    var dioRequest = Dio();

    var formData;
    formData = FormData();
    formData.files.addAll([
      MapEntry('name', MultipartFile.fromString(name,),),
      MapEntry('description', MultipartFile.fromString(description,),),
      MapEntry('relationship', MultipartFile.fromString(relationship,),),
      MapEntry('location', MultipartFile.fromString(location,),),
      MapEntry('dob', MultipartFile.fromString(dob,),),
      MapEntry('rip', MultipartFile.fromString(rip,),),
      MapEntry('state', MultipartFile.fromString(state,),),
      MapEntry('country', MultipartFile.fromString(country,),),
      MapEntry('precinct', MultipartFile.fromString(precinct,),),
    ]);

    var response = await dioRequest.put('http://fbp.dev1.koda.ws/api/v1/pages/blm/$memorialId', data: formData,
      options: Options(
        headers: <String, dynamic>{
          'access-token': getAccessToken,
          'uid': getUID,
          'client': getClient,
        }
      ),  
    );


    if(response.statusCode == 200){
      // var newValue = json.decode(response.body);
      // return APIBLMShowPageDetailsMain.fromJson(newValue);
      result = true;
    }

    
  }catch(e){
    print('The e is $e');
    result = false;
  }

  return result;
}