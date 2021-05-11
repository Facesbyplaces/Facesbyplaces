import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIBLMHomeTabNotificationMain> apiBLMHomeNotificationsTab({required int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/mainpages/notifications/?page=$page',
    options: Options(
      followRedirects: false,
      validateStatus: (status) {
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

  // print('The status code of blm home notifications tab is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIBLMHomeTabNotificationMain.fromJson(newData);
  }else{
    throw Exception('Failed to get the notifications');
  }
}

class APIBLMHomeTabNotificationMain{
  int blmItemsRemaining;
  List<APIBLMHomeTabNotificationExtended> blmNotification;

  APIBLMHomeTabNotificationMain({required this.blmItemsRemaining, required this.blmNotification});

  factory APIBLMHomeTabNotificationMain.fromJson(Map<String, dynamic> parsedJson){

    var newList = parsedJson['notifs'] as List;
    List<APIBLMHomeTabNotificationExtended> newNotification = newList.map((i) => APIBLMHomeTabNotificationExtended.fromJson(i)).toList();

    return APIBLMHomeTabNotificationMain(
      blmItemsRemaining: parsedJson['itemsremaining'],
      blmNotification: newNotification,
    );
  }
}

class APIBLMHomeTabNotificationExtended{
  int homeTabNotificationId;
  String homeTabNotificationCreatedAt;
  String homeTabNotificationUpdatedAt;
  int homeTabNotificationRecipientId;
  APIBLMHomeTabNotificationExtendedActor homeTabNotificationActor;
  bool homeTabNotificationRead;
  String homeTabNotificationAction;
  int homeTabNotificationPostId;
  String homeTabNotificationNotificationType;

  APIBLMHomeTabNotificationExtended({required this.homeTabNotificationId, required this.homeTabNotificationCreatedAt, required this.homeTabNotificationUpdatedAt, required this.homeTabNotificationRecipientId, required this.homeTabNotificationActor, required this.homeTabNotificationRead, required this.homeTabNotificationAction, required this.homeTabNotificationPostId, required this.homeTabNotificationNotificationType});

  factory APIBLMHomeTabNotificationExtended.fromJson(Map<String, dynamic> parsedJson){

    return APIBLMHomeTabNotificationExtended(
      homeTabNotificationId: parsedJson['id'],
      homeTabNotificationCreatedAt: parsedJson['created_at'] != null ? parsedJson['created_at'] : '',
      homeTabNotificationUpdatedAt: parsedJson['updated_at'] != null ? parsedJson['updated_at'] : '',
      homeTabNotificationRecipientId: parsedJson['recipient_id'],
      homeTabNotificationActor: APIBLMHomeTabNotificationExtendedActor.fromJson(parsedJson['actor']),
      homeTabNotificationRead: parsedJson['read'],
      homeTabNotificationAction: parsedJson['action'] != null ? parsedJson['action'] : '',
      homeTabNotificationPostId: parsedJson['postId'],
      homeTabNotificationNotificationType: parsedJson['notif_type'] != null ? parsedJson['notif_type'] : '',
    );
  }
}

class APIBLMHomeTabNotificationExtendedActor{
  int homeTabNotificationActorId;
  String homeTabNotificationActorImage;

  APIBLMHomeTabNotificationExtendedActor({required this.homeTabNotificationActorId, required this.homeTabNotificationActorImage});

  factory APIBLMHomeTabNotificationExtendedActor.fromJson(Map<String, dynamic> parsedJson){

    return APIBLMHomeTabNotificationExtendedActor(
      homeTabNotificationActorId: parsedJson['id'],
      homeTabNotificationActorImage: parsedJson['image'] != null ? parsedJson['image'] : '',
    );
  }
}