import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowAccountDetails> apiBLMShowAccountDetails({required int userId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get(
    Uri.http('http://fbp.dev1.koda.ws/api/v1/users/getDetails?user_id=$userId&account_type=1', ''),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMShowAccountDetails.fromJson(newValue);
  }else{
    throw Exception('Failed to get the post');
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
      showAccountDetailsFirstName: parsedJson['first_name'],
      showAccountDetailsLastName: parsedJson['last_name'],
      showAccountDetailsEmail: parsedJson['email'],
      showAccountDetailsPhoneNumber: parsedJson['phone_number'],
      showAccountDetailsQuestion: parsedJson['question'],
    );
  }
}
