import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowSwitchStatus> apiRegularShowSwitchStatus(int memorialId) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/pageadmin/hideStatus/Memorial/$memorialId',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The status code is ${response.statusCode}');
  // print('The status body is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularShowSwitchStatus.fromJson(newValue);
  }else{
    throw Exception('Failed to get the lists.');
  }
}

class APIRegularShowSwitchStatus{
  bool family;
  bool friends;
  bool followers;
  bool success;

  APIRegularShowSwitchStatus({this.family, this.friends, this.followers, this.success});

  factory APIRegularShowSwitchStatus.fromJson(Map<String, dynamic> parsedJson){

    return APIRegularShowSwitchStatus(
      family: parsedJson['family'],
      friends: parsedJson['friends'],
      followers: parsedJson['followers'],
      success: true,
    );
  }
}
