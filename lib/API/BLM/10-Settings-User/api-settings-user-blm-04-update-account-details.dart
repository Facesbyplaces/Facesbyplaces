import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiBLMUpdateAccountDetails({String firstName, String lastName, String email, String phoneNumber, String question}) async{

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
      MapEntry('first_name', MultipartFile.fromString(firstName),),
      MapEntry('last_name', MultipartFile.fromString(lastName)),
      MapEntry('email', MultipartFile.fromString(email)),
      MapEntry('phone_number', MultipartFile.fromString(phoneNumber)),
      MapEntry('question', MultipartFile.fromString(question)),
    ]);

    var response = await dioRequest.put('http://fbp.dev1.koda.ws/api/v1/users/updateDetails', data: formData,
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
    print('Error in settings update account details: $e');
    result = false;
  }

  return result;
}