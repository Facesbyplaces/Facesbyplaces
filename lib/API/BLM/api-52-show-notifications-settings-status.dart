// http://fbp.dev1.koda.ws/api/v1/notifications/notifSettingsStatus

// http://fbp.dev1.koda.ws/api/v1/users/otherDetailsStatus


import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowNotificationStatus> apiBLMShowNotificationStatus({int userId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get(
    'http://fbp.dev1.koda.ws/api/v1/notifications/notifSettingsStatus',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The status of show notification status is ${response.statusCode}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMShowNotificationStatus.fromJson(newValue);
  }else{
    throw Exception('Failed to get the post');
  }
}



class APIBLMShowNotificationStatus{
  bool newMemorial;
  bool newActivities;
  bool postLikes;
  bool postComments;
  bool addFamily;
  bool addFriends;
  bool addAdmin;

  APIBLMShowNotificationStatus({this.newMemorial, this.newActivities, this.postLikes, this.postComments, this.addFamily, this.addFriends, this.addAdmin});

  factory APIBLMShowNotificationStatus.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowNotificationStatus(
      newMemorial: parsedJson['newMemorial'],
      newActivities: parsedJson['newAcitivites'],
      postLikes: parsedJson['postLikes'],
      postComments: parsedJson['postComments'],
      addFamily: parsedJson['addFamily'],
      addFriends: parsedJson['addFriends'],
      addAdmin: parsedJson['addAdmin'],
    );
  }
}
