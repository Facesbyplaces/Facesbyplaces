import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowSwitchStatus> apiBLMShowSwitchStatus({required int memorialId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get(
    Uri.http('http://fbp.dev1.koda.ws/api/v1/pageadmin/hideStatus/Blm/$memorialId', ''),
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
    throw Exception('Failed to show switch status');
  }
}

class APIBLMShowSwitchStatus{
  bool switchStatusFamily;
  bool switchStatusFriends;
  bool switchStatusFollowers;
  bool switchStatusSuccess;

  APIBLMShowSwitchStatus({required this.switchStatusFamily, required this.switchStatusFriends, required this.switchStatusFollowers, required this.switchStatusSuccess});

  factory APIBLMShowSwitchStatus.fromJson(Map<String, dynamic> parsedJson){

    return APIBLMShowSwitchStatus(
      switchStatusFamily: parsedJson['family'],
      switchStatusFriends: parsedJson['friends'],
      switchStatusFollowers: parsedJson['followers'],
      switchStatusSuccess: true,
    );
  }
}
