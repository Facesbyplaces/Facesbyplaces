import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiRegularUpdateOtherDetails({String birthdate, String birthplace, String email, String address, String phoneNumber}) async{

  bool result = false;

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  try{
    
    var dioRequest = Dio();
    var formData = FormData();

    formData.files.addAll([
      MapEntry('birthdate', MultipartFile.fromString(birthdate),),
      MapEntry('birthplace', MultipartFile.fromString(birthplace)),
      MapEntry('email', MultipartFile.fromString(email)),
      MapEntry('address', MultipartFile.fromString(address)),
      MapEntry('phone_number', MultipartFile.fromString(phoneNumber)),
    ]);

    var response = await dioRequest.put('http://fbp.dev1.koda.ws/api/v1/users/updateOtherInfos', data: formData,
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
    result = false;
  }

  return result;
}