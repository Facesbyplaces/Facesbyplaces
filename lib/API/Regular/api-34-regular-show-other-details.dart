import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowOtherDetails> apiRegularShowOtherDetails(int userId) async{

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
  String birthdate;
  String birthplace;
  String email;
  String address;
  String phoneNumber;

  APIRegularShowOtherDetails({this.birthdate, this.birthplace, this.email, this.address, this.phoneNumber});

  factory APIRegularShowOtherDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowOtherDetails(
      birthdate: parsedJson['birthdate'],
      birthplace: parsedJson['birthplace'],
      email: parsedJson['email'],
      address: parsedJson['address'],
      phoneNumber: parsedJson['phone_number'],
    );
  }
}
