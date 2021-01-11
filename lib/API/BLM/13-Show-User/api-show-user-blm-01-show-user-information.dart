import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowUserInformation> apiBLMShowUserInformation({int userId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/users/getDetails?user_id=$userId',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMShowUserInformation.fromJson(newValue);
  }else{
    throw Exception('Failed to get the user profile');
  }
}

class APIBLMShowUserInformation{
  int id;
  String firstName;
  String lastName;
  String birthdate;
  String birthplace;
  String homeAddress;
  String emailAddress;
  String contactNumber;
  String image;
  
  APIBLMShowUserInformation({this.id, this.firstName, this.lastName, this.birthdate, this.birthplace, this.homeAddress, this.emailAddress, this.contactNumber, this.image});

  factory APIBLMShowUserInformation.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowUserInformation(
      id: parsedJson['id'],
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      birthdate: parsedJson['birthdate'],
      birthplace: parsedJson['birthplace'],
      homeAddress: parsedJson['address'],
      emailAddress: parsedJson['email'],
      contactNumber: parsedJson['phone_number'],
      image: parsedJson['image'],
    );
  }
}


