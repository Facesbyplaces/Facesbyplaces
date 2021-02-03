import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowSwitchStatus> apiRegularShowSwitchStatus({int memorialId}) async{

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

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularShowSwitchStatus.fromJson(newValue);
  }else{
    throw Exception('Failed to get the lists.');
  }
}

class APIRegularShowSwitchStatus{
  bool showSwitchStatusFamily;
  bool showSwitchStatusFriends;
  bool showSwitchStatusFollowers;
  bool showSwitchStatusSuccess;

  APIRegularShowSwitchStatus({this.showSwitchStatusFamily, this.showSwitchStatusFriends, this.showSwitchStatusFollowers, this.showSwitchStatusSuccess});

  factory APIRegularShowSwitchStatus.fromJson(Map<String, dynamic> parsedJson){

    return APIRegularShowSwitchStatus(
      showSwitchStatusFamily: parsedJson['family'],
      showSwitchStatusFriends: parsedJson['friends'],
      showSwitchStatusFollowers: parsedJson['followers'],
      showSwitchStatusSuccess: true,
    );
  }
}
