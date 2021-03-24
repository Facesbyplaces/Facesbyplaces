import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIBLMShowAccountDetails> apiBLMShowAccountDetails({required int userId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/users/getDetails?user_id=$userId&account_type=1',
    options: Options(
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  print('The status code of user is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIBLMShowAccountDetails.fromJson(newData);
  }else{
    throw Exception('Failed to get the account details');
  }
}

class APIBLMShowAccountDetails{
  String showAccountDetailsFirstName;
  String showAccountDetailsLastName;
  String showAccountDetailsEmail;
  String showAccountDetailsPhoneNumber;
  String showAccountDetailsQuestion;
  
  APIBLMShowAccountDetails({required this.showAccountDetailsFirstName, required this.showAccountDetailsLastName, required this.showAccountDetailsEmail, required this.showAccountDetailsPhoneNumber, required this.showAccountDetailsQuestion});

  factory APIBLMShowAccountDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowAccountDetails(
      showAccountDetailsFirstName: parsedJson['first_name'] != null ? parsedJson['first_name'] : '',
      showAccountDetailsLastName: parsedJson['last_name'] != null ? parsedJson['last_name'] : '',
      showAccountDetailsEmail: parsedJson['email'] != null ? parsedJson['email'] : '',
      showAccountDetailsPhoneNumber: parsedJson['phone_number'] != null ? parsedJson['phone_number'] : '',
      showAccountDetailsQuestion: parsedJson['question'] != null ? parsedJson['question'] : '',
    );
  }
}