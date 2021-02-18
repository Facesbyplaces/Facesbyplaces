import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMHomeTabNotificationMain> apiBLMHomeNotificationsTab({int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';
  
  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/mainpages/notifications/?page=$page',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMHomeTabNotificationMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the notifications');
  }
}

class APIBLMHomeTabNotificationMain{
  int blmItemsRemaining;
  List<APIBLMHomeTabNotificationExtended> blmNotification;

  APIBLMHomeTabNotificationMain({this.blmItemsRemaining, this.blmNotification});

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

  APIBLMHomeTabNotificationExtended({this.homeTabNotificationId, this.homeTabNotificationCreatedAt, this.homeTabNotificationUpdatedAt, this.homeTabNotificationRecipientId, this.homeTabNotificationActor, this.homeTabNotificationRead, this.homeTabNotificationAction, this.homeTabNotificationPostId, this.homeTabNotificationNotificationType});

  factory APIBLMHomeTabNotificationExtended.fromJson(Map<String, dynamic> parsedJson){

    return APIBLMHomeTabNotificationExtended(
      homeTabNotificationId: parsedJson['id'],
      homeTabNotificationCreatedAt: parsedJson['created_at'],
      homeTabNotificationUpdatedAt: parsedJson['updated_at'],
      homeTabNotificationRecipientId: parsedJson['recipient_id'],
      homeTabNotificationActor: APIBLMHomeTabNotificationExtendedActor.fromJson(parsedJson['actor']),
      homeTabNotificationRead: parsedJson['read'],
      homeTabNotificationAction: parsedJson['action'],
      homeTabNotificationPostId: parsedJson['postId'],
      homeTabNotificationNotificationType: parsedJson['notif_type'],
    );
  }
}

class APIBLMHomeTabNotificationExtendedActor{
  int homeTabNotificationActorId;
  String homeTabNotificationActorImage;

  APIBLMHomeTabNotificationExtendedActor({this.homeTabNotificationActorId, this.homeTabNotificationActorImage});

  factory APIBLMHomeTabNotificationExtendedActor.fromJson(Map<String, dynamic> parsedJson){

    return APIBLMHomeTabNotificationExtendedActor(
      homeTabNotificationActorId: parsedJson['id'],
      homeTabNotificationActorImage: parsedJson['image'],
    );
  }
}