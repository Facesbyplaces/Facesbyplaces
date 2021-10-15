import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularShowAccountDetails> apiRegularShowAccountDetails({required int userId}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('https://facesbyplaces.com/api/v1/users/getDetails?user_id=$userId',
    options: Options(
      headers: <String, dynamic>{
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
    return APIRegularShowAccountDetails.fromJson(newData);
  }else{
    throw Exception('Error occurred: ${response.statusMessage}');
  }
}

class APIRegularShowAccountDetails{
  String showAccountDetailsFirstName;
  String showAccountDetailsLastName;
  String showAccountDetailsEmail;
  String showAccountDetailsPhoneNumber;
  String showAccountDetailsQuestion;
  APIRegularShowAccountDetails({required this.showAccountDetailsFirstName, required this.showAccountDetailsLastName, required this.showAccountDetailsEmail, required this.showAccountDetailsPhoneNumber, required this.showAccountDetailsQuestion});

  factory APIRegularShowAccountDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowAccountDetails(
      showAccountDetailsFirstName: parsedJson['first_name'] ?? '',
      showAccountDetailsLastName: parsedJson['last_name'] ?? '',
      showAccountDetailsEmail: parsedJson['email'] ?? '',
      showAccountDetailsPhoneNumber: parsedJson['phone_number'] ?? '',
      showAccountDetailsQuestion: parsedJson['question'] ?? '',
    );
  }
}
