import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowNotificationStatus> apiRegularShowNotificationStatus({int userId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/notifications/notifSettingsStatus',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The status code of notification settings is ${response.statusCode}');
  print('The status body of notification settings is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularShowNotificationStatus.fromJson(newValue);
  }else{
    throw Exception('Failed to get the post');
  }
}

class APIRegularShowNotificationStatus{
  bool newMemorial;
  bool newActivities;
  bool postLikes;
  bool postComments;
  bool addFamily;
  bool addFriends;
  bool addAdmin;

  APIRegularShowNotificationStatus({this.newMemorial, this.newActivities, this.postLikes, this.postComments, this.addFamily, this.addFriends, this.addAdmin});

  factory APIRegularShowNotificationStatus.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowNotificationStatus(
      newMemorial: parsedJson['newMemorial'],
      newActivities: parsedJson['newActivities'],
      postLikes: parsedJson['postLikes'],
      postComments: parsedJson['postComments'],
      addFamily: parsedJson['addFamily'],
      addFriends: parsedJson['addFriends'],
      addAdmin: parsedJson['addAdmin'],
    );
  }
}
