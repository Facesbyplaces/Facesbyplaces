import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiRegularUpdateAccountDetails({required String firstName, required String lastName, required String email, required String phoneNumber, required String question}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();
  FormData formData = FormData();

  formData.files.addAll([
    MapEntry('first_name', MultipartFile.fromString(firstName),),
    MapEntry('last_name', MultipartFile.fromString(lastName)),
    MapEntry('email', MultipartFile.fromString(email)),
    MapEntry('phone_number', MultipartFile.fromString(phoneNumber)),
    MapEntry('question', MultipartFile.fromString(question)),
  ]);

  var response = await dioRequest.put('http://facesbyplaces.com/api/v1/users/updateDetails', data: formData,
    options: Options(
      followRedirects: false,
      validateStatus: (status){
        return status! < 600;
      },
      headers: <String, dynamic>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),
  );

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}