import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularHomeTabNotificationMain> apiRegularHomeNotificationsTab({required int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/mainpages/notifications/?page=$page',
    options: Options(
      headers: <String, dynamic>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),
  );

  print('The status code of main page - notifications is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIRegularHomeTabNotificationMain.fromJson(newData);
  }else{
    throw Exception('Error occurred in main page - notifications: ${response.statusMessage}');
  }
}

class APIRegularHomeTabNotificationMain{
  int almItemsRemaining;
  List<APIRegularHomeTabNotificationExtended> almNotification;

  APIRegularHomeTabNotificationMain({required this.almItemsRemaining, required this.almNotification});

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

  APIRegularHomeTabNotificationExtended({required this.homeTabNotificationId, required this.homeTabNotificationCreatedAt, required this.homeTabNotificationUpdatedAt, required this.homeTabNotificationRecipientId, required this.homeTabNotificationActor, required this.homeTabNotificationRead, required this.homeTabNotificationAction, required this.homeTabNotificationPostId, required this.homeTabNotificationNotificationType});

  factory APIRegularHomeTabNotificationExtended.fromJson(Map<String, dynamic> parsedJson){

    return APIRegularHomeTabNotificationExtended(
      homeTabNotificationId: parsedJson['id'],
      homeTabNotificationCreatedAt: parsedJson['created_at'] != null ? parsedJson['created_at'] : '',
      homeTabNotificationUpdatedAt: parsedJson['updated_at'] != null ? parsedJson['updated_at'] : '',
      homeTabNotificationRecipientId: parsedJson['recipient_id'],
      homeTabNotificationActor: APIRegularHomeTabNotificationExtendedActor.fromJson(parsedJson['actor']),
      homeTabNotificationRead: parsedJson['read'],
      homeTabNotificationAction: parsedJson['action'] != null ? parsedJson['action'] : '',
      homeTabNotificationPostId: parsedJson['postId'],
      homeTabNotificationNotificationType: parsedJson['notif_type'] != null ? parsedJson['notif_type'] : '',
    );
  }
}

class APIRegularHomeTabNotificationExtendedActor{
  int homeTabNotificationActorId;
  String homeTabNotificationActorImage;

  APIRegularHomeTabNotificationExtendedActor({required this.homeTabNotificationActorId, required this.homeTabNotificationActorImage});

  factory APIRegularHomeTabNotificationExtendedActor.fromJson(Map<String, dynamic> parsedJson){

    return APIRegularHomeTabNotificationExtendedActor(
      homeTabNotificationActorId: parsedJson['id'],
      homeTabNotificationActorImage: parsedJson['image'] != null ? parsedJson['image'] : '',
    );
  }
}