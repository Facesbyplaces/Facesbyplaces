import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowOtherDetails> apiBLMShowOtherDetails({int userId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/users/getOtherInfos?user_id=$userId&account_type=1',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMShowOtherDetails.fromJson(newValue);
  }else{
    throw Exception('Failed to get the details.');
  }
}

class APIBLMShowOtherDetails{
  String birthdate;
  String birthplace;
  String email;
  String address;
  String phoneNumber;

  APIBLMShowOtherDetails({this.birthdate, this.birthplace, this.email, this.address, this.phoneNumber});

  factory APIBLMShowOtherDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowOtherDetails(
      birthdate: parsedJson['birthdate'] != null ? parsedJson['birthdate'] : '',
      birthplace: parsedJson['birthplace'] != null ? parsedJson['birthplace'] : '',
      email: parsedJson['email'] != null ? parsedJson['email'] : '',
      address: parsedJson['address'] != null ? parsedJson['address'] : '',
      phoneNumber: parsedJson['phone_number'] != null ? parsedJson['phone_number'] : '',
    );
  }
}
