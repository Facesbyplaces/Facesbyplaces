import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowAccountDetails> apiRegularShowAccountDetails({required int userId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get(
    Uri.http('http://fbp.dev1.koda.ws/api/v1/users/getDetails?user_id=$userId', ''),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularShowAccountDetails.fromJson(newValue);
  }else{
    throw Exception('Failed to show account details');
  }
}

class APIRegularShowAccountDetails{
  int showAccountDetailsId;
  String showAccountDetailsFirstName;
  String showAccountDetailsLastName;
  String showAccountDetailsEmail;
  String showAccountDetailsPhoneNumber;
  String showAccountDetailsQuestion;
  
  APIRegularShowAccountDetails({required this.showAccountDetailsId, required this.showAccountDetailsFirstName, required this.showAccountDetailsLastName, required this.showAccountDetailsEmail, required this.showAccountDetailsPhoneNumber, required this.showAccountDetailsQuestion});

  factory APIRegularShowAccountDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowAccountDetails(
      showAccountDetailsId: parsedJson['id'],
      showAccountDetailsFirstName: parsedJson['first_name'],
      showAccountDetailsLastName: parsedJson['last_name'],
      showAccountDetailsEmail: parsedJson['email'],
      showAccountDetailsPhoneNumber: parsedJson['phone_number'],
      showAccountDetailsQuestion: parsedJson['question'],
    );
  }
}
