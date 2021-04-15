import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiBLMUpdatePageDetails({required int memorialId, required String name, required String description, required String relationship, required String location, required String dob, required String rip, required String state, required String country, required String precinct}) async{

  bool result = false;

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  try{
    Dio dioRequest = Dio();
    FormData formData = FormData();
    
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

    print('The status code of blm update page details is ${response.statusCode}');

    if(response.statusCode == 200){
      result = true;
    }
    
  }catch(e){
    print('Error in page update details: $e');
    result = false;
  }

  return result;
}