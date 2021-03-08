import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowNotificationStatus> apiBLMShowNotificationStatus({required int userId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get(
    Uri.http('http://fbp.dev1.koda.ws/api/v1/notifications/notifSettingsStatus', ''),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMShowNotificationStatus.fromJson(newValue);
  }else{
    throw Exception('Failed to get the post');
  }
}

class APIBLMShowNotificationStatus{
  bool showNotificationStatusNewMemorial;
  bool showNotificationStatusNewActivities;
  bool showNotificationStatusPostLikes;
  bool showNotificationStatusPostComments;
  bool showNotificationStatusAddFamily;
  bool showNotificationStatusAddFriends;
  bool showNotificationStatusAddAdmin;

  APIBLMShowNotificationStatus({required this.showNotificationStatusNewMemorial, required this.showNotificationStatusNewActivities, required this.showNotificationStatusPostLikes, required this.showNotificationStatusPostComments, required this.showNotificationStatusAddFamily, required this.showNotificationStatusAddFriends, required this.showNotificationStatusAddAdmin});

  factory APIBLMShowNotificationStatus.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowNotificationStatus(
      showNotificationStatusNewMemorial: parsedJson['newMemorial'],
      showNotificationStatusNewActivities: parsedJson['newActivities'],
      showNotificationStatusPostLikes: parsedJson['postLikes'],
      showNotificationStatusPostComments: parsedJson['postComments'],
      showNotificationStatusAddFamily: parsedJson['addFamily'],
      showNotificationStatusAddFriends: parsedJson['addFriends'],
      showNotificationStatusAddAdmin: parsedJson['addAdmin'],
    );
  }
}
