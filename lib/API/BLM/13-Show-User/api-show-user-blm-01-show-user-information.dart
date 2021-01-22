import 'package:date_time_format/date_time_format.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowUserInformation> apiBLMShowUserInformation({int userId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/users/showDetails?user_id=$userId',
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
    // String newBirthdate = parsedJson['birthdate'];
    // DateTime dateTime = DateTime.parse(newBirthdate);

    DateTime dateTime;
    String newBirthdate;

    if(parsedJson['birthdate'] != null){
      String newValue = parsedJson['birthdate'];
      dateTime = DateTime.parse(newValue);
      newBirthdate = dateTime.format(AmericanDateFormats.standardWithComma);
    }else{
      newBirthdate = '';
    }

    return APIBLMShowUserInformation(
      // id: parsedJson['id'],
      // firstName: parsedJson['first_name'],
      // lastName: parsedJson['last_name'],
      // birthdate: dateTime.format(AmericanDateFormats.standardWithComma),
      // birthplace: parsedJson['birthplace'],
      // homeAddress: parsedJson['address'],
      // emailAddress: parsedJson['email'],
      // contactNumber: parsedJson['phone_number'],
      // image: parsedJson['image'],
      firstName: parsedJson['first_name'] != null ? parsedJson['first_name'] : '',
      lastName: parsedJson['last_name'] != null ? parsedJson['last_name'] : '',
      birthdate: newBirthdate,
      birthplace: parsedJson['birthplace'] != null ? parsedJson['birthplace'] : '',
      homeAddress: parsedJson['address'] != null ? parsedJson['address'] : '',
      emailAddress: parsedJson['email'] != null ? parsedJson['email'] : '',
      contactNumber: parsedJson['phone_number'] != null ? parsedJson['phone_number'] : '',
      image: parsedJson['image'] != null ? parsedJson['image'] : '',
    );
  }
}

