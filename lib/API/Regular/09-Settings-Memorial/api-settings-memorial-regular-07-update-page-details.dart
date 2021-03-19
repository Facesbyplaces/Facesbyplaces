import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiRegularUpdatePageDetails({required String name, required String relationship, required String dob, required String rip, required String country, required String cemetery, required int memorialId}) async{

  bool result = false;

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  try{
    Dio dioRequest = Dio();
    FormData formData = FormData();
    
    formData.files.addAll([
      MapEntry('name', MultipartFile.fromString(name,),),
      MapEntry('relationship', MultipartFile.fromString(relationship,),),
      MapEntry('dob', MultipartFile.fromString(dob,),),
      MapEntry('rip', MultipartFile.fromString(rip,),),
      MapEntry('country', MultipartFile.fromString(country,),),
      MapEntry('cemetery', MultipartFile.fromString(cemetery,),),
    ]);

    var response = await dioRequest.put('http://fbp.dev1.koda.ws/api/v1/pages/memorials/$memorialId', data: formData,
      options: Options(
        headers: <String, dynamic>{
          'access-token': getAccessToken,
          'uid': getUID,
          'client': getClient,
        }
      ),
    );

    if(response.statusCode == 200){
      result = true;
    }
    
  }catch(e){
    print('Error in update page details: $e');
    result = false;
  }

  return result;
}