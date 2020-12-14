import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowSwitchStatus> apiBLMShowSwitchStatus(int memorialId) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/pageadmin/hideStatus/Blm/$memorialId',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMShowSwitchStatus.fromJson(newValue);
  }else{
    throw Exception('Failed to get the lists.');
  }
}



class APIBLMShowSwitchStatus{
  bool family;
  bool friends;
  bool followers;
  bool success;

  APIBLMShowSwitchStatus({this.family, this.friends, this.followers, this.success});

  factory APIBLMShowSwitchStatus.fromJson(Map<String, dynamic> parsedJson){

    return APIBLMShowSwitchStatus(
      family: parsedJson['family'],
      friends: parsedJson['friends'],
      followers: parsedJson['followers'],
      success: true,
    );
  }
}