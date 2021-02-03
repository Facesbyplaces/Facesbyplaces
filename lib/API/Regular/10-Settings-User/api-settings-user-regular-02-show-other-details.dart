import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowOtherDetails> apiRegularShowOtherDetails({int userId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/users/getOtherInfos?user_id=$userId',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularShowOtherDetails.fromJson(newValue);
  }else{
    throw Exception('Failed to get the post');
  }
}

class APIRegularShowOtherDetails{
  String showOtherDetailsBirthdate;
  String showOtherDetailsBirthplace;
  String showOtherDetailsEmail;
  String showOtherDetailsAddress;
  String showOtherDetailsPhoneNumber;

  APIRegularShowOtherDetails({this.showOtherDetailsBirthdate, this.showOtherDetailsBirthplace, this.showOtherDetailsEmail, this.showOtherDetailsAddress, this.showOtherDetailsPhoneNumber});

  factory APIRegularShowOtherDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowOtherDetails(
      showOtherDetailsBirthdate: parsedJson['birthdate'],
      showOtherDetailsBirthplace: parsedJson['birthplace'],
      showOtherDetailsEmail: parsedJson['email'],
      showOtherDetailsAddress: parsedJson['address'],
      showOtherDetailsPhoneNumber: parsedJson['phone_number'],
    );
  }
}


