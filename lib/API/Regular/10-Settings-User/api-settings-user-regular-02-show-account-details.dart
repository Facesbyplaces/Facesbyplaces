import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowAccountDetails> apiRegularShowAccountDetails(int userId) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/users/getDetails?user_id=$userId',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The account details status is ${response.statusCode}');
  print('The account details body is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularShowAccountDetails.fromJson(newValue);
  }else{
    throw Exception('Failed to get the post');
  }
}

class APIRegularShowAccountDetails{
  // String firstName;
  // String lastName;
  // String email;
  // String phoneNumber;
  // String question;
  
  // APIRegularShowAccountDetails({this.firstName, this.lastName, this.email, this.phoneNumber, this.question});

  // factory APIRegularShowAccountDetails.fromJson(Map<String, dynamic> parsedJson){
  //   return APIRegularShowAccountDetails(
  //     firstName: parsedJson['first_name'],
  //     lastName: parsedJson['last_name'],
  //     email: parsedJson['email'],
  //     phoneNumber: parsedJson['phone_number'],
  //     question: parsedJson['question'],
  //   );
  // }

  int id;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String question;
  
  APIRegularShowAccountDetails({this.id, this.firstName, this.lastName, this.email, this.phoneNumber, this.question});

  factory APIRegularShowAccountDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowAccountDetails(
      id: parsedJson['id'],
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      email: parsedJson['email'],
      phoneNumber: parsedJson['phone_number'],
      question: parsedJson['question'],
    );
  }
}
