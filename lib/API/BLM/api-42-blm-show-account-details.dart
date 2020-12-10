import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowAccountDetails> apiBLMShowAccountDetails(int userId) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get(
    'http://fbp.dev1.koda.ws/api/v1/users/getDetails?user_id=$userId',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The status of account details is ${response.statusCode}');
  print('The status of account details is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMShowAccountDetails.fromJson(newValue);
  }else{
    throw Exception('Failed to get the post');
  }
}



class APIBLMShowAccountDetails{
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String question;
  
  APIBLMShowAccountDetails({this.firstName, this.lastName, this.email, this.phoneNumber, this.question});

  factory APIBLMShowAccountDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowAccountDetails(
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      email: parsedJson['email'],
      phoneNumber: parsedJson['phone_number'],
      question: parsedJson['question'],
    );
  }
}
