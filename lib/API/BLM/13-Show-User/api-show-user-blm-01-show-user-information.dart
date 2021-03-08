import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowUserInformation> apiBLMShowUserInformation({required int userId, required int accountType}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get(
    Uri.http('http://fbp.dev1.koda.ws/api/v1/users/showDetails?user_id=$userId&account_type=$accountType', ''),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The user information code is ${response.statusCode}');
  print('The user information body is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMShowUserInformation.fromJson(newValue);
  }else{
    throw Exception('Failed to get the user profile');
  }
}

class APIBLMShowUserInformation{
  int showUserInformationId;
  String showUserInformationFirstName;
  String showUserInformationLastName;
  String showUserInformationBirthdate;
  String showUserInformationBirthplace;
  String showUserInformationHomeAddress;
  String showUserInformationEmailAddress;
  String showUserInformationContactNumber;
  String showUserInformationImage;
  
  APIBLMShowUserInformation({required this.showUserInformationId, required this.showUserInformationFirstName, required this.showUserInformationLastName, required this.showUserInformationBirthdate, required this.showUserInformationBirthplace, required this.showUserInformationHomeAddress, required this.showUserInformationEmailAddress, required this.showUserInformationContactNumber, required this.showUserInformationImage});

  factory APIBLMShowUserInformation.fromJson(Map<String, dynamic> parsedJson){

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


