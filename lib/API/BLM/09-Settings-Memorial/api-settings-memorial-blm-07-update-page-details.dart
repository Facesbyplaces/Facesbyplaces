import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiBLMUpdatePageDetails({int memorialId, String name, String description, String relationship, String location, String dob, String rip, String state, String country, String precinct}) async{

  bool result = false;

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

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

    print('The access token in blm update account details is ${response.headers['access-token'].toString().replaceAll('[', '').replaceAll(']', '')}');
    print('The uid in blm update account details is ${response.headers['uid'].toString().replaceAll('[', '').replaceAll(']', '')}');
    print('The client in blm update account details is ${response.headers['client'].toString().replaceAll('[', '').replaceAll(']', '')}');

    print('The status code of update details is ${response.statusCode}');
    print('The status data of update details is ${response.data}');

    if(response.statusCode == 200){
      result = true;
      if(response.headers['access-token'].toString().replaceAll('[', '').replaceAll(']', '') != null && response.headers['uid'].toString().replaceAll('[', '').replaceAll(']', '') != null && response.headers['client'].toString().replaceAll('[', '').replaceAll(']', '') != null){
        sharedPrefs.setString('blm-access-token', response.headers['access-token'].toString().replaceAll('[' ,'',).replaceAll(']', ''));
        sharedPrefs.setString('blm-uid', response.headers['uid'].toString().replaceAll('[' ,'',).replaceAll(']', ''));    
        sharedPrefs.setString('blm-client', response.headers['client'].toString().replaceAll('[' ,'',).replaceAll(']', ''));
      }
    }

    
  }catch(e){
    print('The page details is $e');
    result = false;
  }

  return result;
}