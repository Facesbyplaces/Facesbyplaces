import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularShowOtherDetails> apiRegularShowOtherDetails({required int userId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/users/getOtherInfos?user_id=$userId',
    options: Options(
      headers: <String, dynamic>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),
  );

  print('The status code of other details is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIRegularShowOtherDetails.fromJson(newData);
  }else{
    throw Exception('Error occurred: ${response.statusMessage}');
  }
}

class APIRegularShowOtherDetails{
  String showOtherDetailsBirthdate;
  String showOtherDetailsBirthplace;
  String showOtherDetailsEmail;
  String showOtherDetailsAddress;
  String showOtherDetailsPhoneNumber;

  APIRegularShowOtherDetails({required this.showOtherDetailsBirthdate, required this.showOtherDetailsBirthplace, required this.showOtherDetailsEmail, required this.showOtherDetailsAddress, required this.showOtherDetailsPhoneNumber});

  factory APIRegularShowOtherDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowOtherDetails(
      showOtherDetailsBirthdate: parsedJson['birthdate'] != null ? parsedJson['birthdate'] : '',
      showOtherDetailsBirthplace: parsedJson['birthplace'] != null ? parsedJson['birthplace'] : '',
      showOtherDetailsEmail: parsedJson['email'] != null ? parsedJson['email'] : '',
      showOtherDetailsAddress: parsedJson['address'] != null ? parsedJson['address'] : '',
      showOtherDetailsPhoneNumber: parsedJson['phone_number'] != null ? parsedJson['phone_number'] : '',
    );
  }
}