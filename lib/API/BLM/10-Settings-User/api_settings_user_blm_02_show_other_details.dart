import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIBLMShowOtherDetails> apiBLMShowOtherDetails({required int userId}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('https://facesbyplaces.com/api/v1/users/getOtherInfos?user_id=$userId&account_type=1',
    options: Options(
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      },
      validateStatus: (status){
        return status! < 600;
      },
      followRedirects: false,
    ),  
  );

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIBLMShowOtherDetails.fromJson(newData);
  }else{
    throw Exception('Failed to get the account details');
  }
}

class APIBLMShowOtherDetails{
  String blmShowOtherDetailsBirthdate;
  String blmShowOtherDetailsBirthplace;
  String blmShowOtherDetailsEmail;
  String blmShowOtherDetailsAddress;
  String blmShowOtherDetailsPhoneNumber;
  APIBLMShowOtherDetails({required this.blmShowOtherDetailsBirthdate, required this.blmShowOtherDetailsBirthplace, required this.blmShowOtherDetailsEmail, required this.blmShowOtherDetailsAddress, required this.blmShowOtherDetailsPhoneNumber});

  factory APIBLMShowOtherDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowOtherDetails(
      blmShowOtherDetailsBirthdate: parsedJson['birthdate'] ?? '',
      blmShowOtherDetailsBirthplace: parsedJson['birthplace'] ?? '',
      blmShowOtherDetailsEmail: parsedJson['email'] ?? '',
      blmShowOtherDetailsAddress: parsedJson['address'] ?? '',
      blmShowOtherDetailsPhoneNumber: parsedJson['phone_number'] ?? '',
    );
  }
}
