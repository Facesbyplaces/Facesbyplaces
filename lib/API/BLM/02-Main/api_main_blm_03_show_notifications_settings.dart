import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIBLMShowNotificationStatus> apiBLMShowNotificationStatus({required int userId}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('https://facesbyplaces.com/api/v1/notifications/notifSettingsStatus',
    options: Options(
      followRedirects: false,
      validateStatus: (status){
        return status! < 600;
      },
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIBLMShowNotificationStatus.fromJson(newData);
  }else{
    throw Exception('Failed to get the notification settings');
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
