import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowOtherDetailsStatus> apiRegularShowOtherDetailsStatus(int userId) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/users/otherDetailsStatus',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularShowOtherDetailsStatus.fromJson(newValue);
  }else{
    throw Exception('Failed to get the post');
  }
}

class APIRegularShowOtherDetailsStatus{
  bool hideBirthdate;
  bool hideBirthplace;
  bool hideEmail;
  bool hideAddress;
  bool hidePhoneNumber;

  APIRegularShowOtherDetailsStatus({this.hideBirthdate, this.hideBirthplace, this.hideEmail, this.hideAddress, this.hidePhoneNumber});

  factory APIRegularShowOtherDetailsStatus.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowOtherDetailsStatus(
      hideBirthdate: parsedJson['hideBirthdate'],
      hideBirthplace: parsedJson['hideBirthplace'],
      hideEmail: parsedJson['hideEmail'],
      hideAddress: parsedJson['hideAddress'],
      hidePhoneNumber: parsedJson['hidePhonenumber'],
    );
  }
}
