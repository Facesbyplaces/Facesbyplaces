import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularHomeTabNotificationMain> apiRegularHomeNotificationsTab({int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

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
    return APIRegularHomeTabNotificationMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the notifications');
  }
}

class APIRegularHomeTabNotificationMain{
  int almItemsRemaining;
  List<APIRegularHomeTabNotificationExtended> almNotification;

  APIRegularHomeTabNotificationMain({this.almItemsRemaining, this.almNotification});

  factory APIRegularHomeTabNotificationMain.fromJson(Map<String, dynamic> parsedJson){

    var newList = parsedJson['notifs'] as List;
    List<APIRegularHomeTabNotificationExtended> newNotification = newList.map((i) => APIRegularHomeTabNotificationExtended.fromJson(i)).toList();

    return APIRegularHomeTabNotificationMain(
      almItemsRemaining: parsedJson['itemsremaining'],
      almNotification: newNotification,
    );
  }
}

class APIRegularHomeTabNotificationExtended{
  int homeTabNotificationId;
  String homeTabNotificationCreatedAt;
  String homeTabNotificationUpdatedAt;
  int homeTabNotificationRecipientId;
  APIRegularHomeTabNotificationExtendedActor homeTabNotificationActor;
  bool homeTabNotificationRead;
  String homeTabNotificationAction;
  int homeTabNotificationPostId;
  String homeTabNotificationNotificationType;

  APIRegularHomeTabNotificationExtended({this.homeTabNotificationId, this.homeTabNotificationCreatedAt, this.homeTabNotificationUpdatedAt, this.homeTabNotificationRecipientId, this.homeTabNotificationActor, this.homeTabNotificationRead, this.homeTabNotificationAction, this.homeTabNotificationPostId, this.homeTabNotificationNotificationType});

  factory APIRegularHomeTabNotificationExtended.fromJson(Map<String, dynamic> parsedJson){

    return APIRegularHomeTabNotificationExtended(
      homeTabNotificationId: parsedJson['id'],
      homeTabNotificationCreatedAt: parsedJson['created_at'],
      homeTabNotificationUpdatedAt: parsedJson['updated_at'],
      homeTabNotificationRecipientId: parsedJson['recipient_id'],
      homeTabNotificationActor: APIRegularHomeTabNotificationExtendedActor.fromJson(parsedJson['actor']),
      homeTabNotificationRead: parsedJson['read'],
      homeTabNotificationAction: parsedJson['action'],
      homeTabNotificationPostId: parsedJson['postId'],
      homeTabNotificationNotificationType: parsedJson['notif_type'],
    );
  }
}

class APIRegularHomeTabNotificationExtendedActor{
  int homeTabNotificationActorId;
  String homeTabNotificationActorImage;

  APIRegularHomeTabNotificationExtendedActor({this.homeTabNotificationActorId, this.homeTabNotificationActorImage});

  factory APIRegularHomeTabNotificationExtendedActor.fromJson(Map<String, dynamic> parsedJson){

    return APIRegularHomeTabNotificationExtendedActor(
      homeTabNotificationActorId: parsedJson['id'],
      homeTabNotificationActorImage: parsedJson['image'],
    );
  }
}