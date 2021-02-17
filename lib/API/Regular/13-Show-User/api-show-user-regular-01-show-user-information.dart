import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowUserInformation> apiRegularShowUserInformation({int userId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/users/showDetails?user_id=$userId',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The status code is ${response.statusCode}');
  print('The status body is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularShowUserInformation.fromJson(newValue);
  }else{
    throw Exception('Failed to get the user profile');
  }
}

class APIRegularShowUserInformation{
  int showUserInformationId;
  String showUserInformationFirstName;
  String showUserInformationLastName;
  String showUserInformationBirthdate;
  String showUserInformationBirthplace;
  String showUserInformationHomeAddress;
  String showUserInformationEmailAddress;
  String showUserInformationContactNumber;
  String showUserInformationImage;
  
  APIRegularShowUserInformation({this.showUserInformationId, this.showUserInformationFirstName, this.showUserInformationLastName, this.showUserInformationBirthdate, this.showUserInformationBirthplace, this.showUserInformationHomeAddress, this.showUserInformationEmailAddress, this.showUserInformationContactNumber, this.showUserInformationImage});

  factory APIRegularShowUserInformation.fromJson(Map<String, dynamic> parsedJson){

    DateTime dateTime;
    String newBirthdate;

    if(parsedJson['birthdate'] != null){
      String newValue = parsedJson['birthdate'];
      dateTime = DateTime.parse(newValue);
      newBirthdate = dateTime.format(AmericanDateFormats.standardWithComma);
    }else{
      newBirthdate = '';
    }

    return APIRegularShowUserInformation(
      showUserInformationId: parsedJson['id'],
      showUserInformationFirstName: parsedJson['first_name'] != null ? parsedJson['first_name'] : '',
      showUserInformationLastName: parsedJson['last_name'] != null ? parsedJson['last_name'] : '',
      showUserInformationBirthdate: newBirthdate,
      showUserInformationBirthplace: parsedJson['birthplace'] != null ? parsedJson['birthplace'] : '',
      showUserInformationHomeAddress: parsedJson['address'] != null ? parsedJson['address'] : '',
      showUserInformationEmailAddress: parsedJson['email'] != null ? parsedJson['email'] : '',
      showUserInformationContactNumber: parsedJson['phone_number'] != null ? parsedJson['phone_number'] : '',
      showUserInformationImage: parsedJson['image'] != null ? parsedJson['image'] : '',
    );
  }
}


