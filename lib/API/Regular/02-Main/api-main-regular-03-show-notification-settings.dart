import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularShowNotificationStatus> apiRegularShowNotificationStatus({required int userId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/notifications/notifSettingsStatus',
    options: Options(
      followRedirects: false,
      validateStatus: (status) {
        return status! < 600;
      },
      headers: <String, dynamic>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),
  );

  print('The status code of regular show notification settings is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIRegularShowNotificationStatus.fromJson(newData);
  }else{
    throw Exception('Error occurred in notification settings: ${response.statusMessage}');
  }
}

class APIRegularShowNotificationStatus{
  bool showNotificationStatusNewMemorial;
  bool showNotificationStatusNewActivities;
  bool showNotificationStatusPostLikes;
  bool showNotificationStatusPostComments;
  bool showNotificationStatusAddFamily;
  bool showNotificationStatusAddFriends;
  bool showNotificationStatusAddAdmin;

  APIRegularShowNotificationStatus({required this.showNotificationStatusNewMemorial, required this.showNotificationStatusNewActivities, required this.showNotificationStatusPostLikes, required this.showNotificationStatusPostComments, required this.showNotificationStatusAddFamily, required this.showNotificationStatusAddFriends, required this.showNotificationStatusAddAdmin});

  factory APIRegularShowNotificationStatus.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowNotificationStatus(
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
