import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiBLMUpdateOtherDetails({String birthdate, String birthplace, String email, String address, String phoneNumber}) async{

  bool result = false;

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  print('The access token is $getAccessToken');
  print('The UID is $getUID');
  print('The client is $getClient');

  print('The birthdate is $birthdate');
  print('The birthplace is $birthplace');
  print('The email is $email');
  print('The address is $address');
  print('The phone number is $phoneNumber');


  try{
    var dioRequest = Dio();

    var formData;
    formData = FormData();
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

    print('The status code for PUT update other details is ${response.statusCode}');
    // print('The status body for update other details is ${response.data}');

    if(response.statusCode == 200){
      result = true;
    }
    
  }catch(e){
    print('The e is $e');
    result = false;
  }

  return result;
}