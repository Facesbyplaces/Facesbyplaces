import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowUserInformation> apiRegularShowUserInformation({int userId}) async{

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

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularShowUserInformation.fromJson(newValue);
  }else{
    throw Exception('Failed to get the user profile');
  }
}

class APIRegularShowUserInformation{
  int id;
  String firstName;
  String lastName;
  String birthdate;
  String birthplace;
  String homeAddress;
  String emailAddress;
  String contactNumber;
  String image;
  
  APIRegularShowUserInformation({this.id, this.firstName, this.lastName, this.birthdate, this.birthplace, this.homeAddress, this.emailAddress, this.contactNumber, this.image});

  factory APIRegularShowUserInformation.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowUserInformation(
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


