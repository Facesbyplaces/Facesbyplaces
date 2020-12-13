import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularHomeTabNotificationMain> apiRegularHomeNotificationsTab(int page) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  var getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  var getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  var getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get(
    'http://fbp.dev1.koda.ws/api/v1/mainpages/notifications/?page=$page',
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
  int itemsRemaining;
  List<APIRegularHomeTabNotificationExtended> notification;

  APIRegularHomeTabNotificationMain({this.itemsRemaining, this.notification});

  factory APIRegularHomeTabNotificationMain.fromJson(Map<String, dynamic> parsedJson){

    var newList = parsedJson['notifs'] as List;
    List<APIRegularHomeTabNotificationExtended> newNotification = newList.map((i) => APIRegularHomeTabNotificationExtended.fromJson(i)).toList();

    return APIRegularHomeTabNotificationMain(
      itemsRemaining: parsedJson['itemsremaining'],
      notification: newNotification,
    );
  }
}


class APIRegularHomeTabNotificationExtended{
  int id;
  String createdAt;
  String updatedAt;
  int recipientId;
  APIRegularHomeTabNotificationExtendedActor actor;
  bool read;
  String action;
  int postId;

  APIRegularHomeTabNotificationExtended({this.id, this.createdAt, this.updatedAt, this.recipientId, this.actor, this.read, this.action, this.postId});

  factory APIRegularHomeTabNotificationExtended.fromJson(Map<String, dynamic> parsedJson){

    return APIRegularHomeTabNotificationExtended(
      id: parsedJson['id'],
      createdAt: parsedJson['created_at'],
      updatedAt: parsedJson['updated_at'],
      recipientId: parsedJson['recipient_id'],
      actor: APIRegularHomeTabNotificationExtendedActor.fromJson(parsedJson['actor']),
      read: parsedJson['read'],
      action: parsedJson['action'],
      postId: parsedJson['postId'],
    );
  }
}



class APIRegularHomeTabNotificationExtendedActor{
  int id;
  String image;

  APIRegularHomeTabNotificationExtendedActor({this.id, this.image});

  factory APIRegularHomeTabNotificationExtendedActor.fromJson(Map<String, dynamic> parsedJson){

    return APIRegularHomeTabNotificationExtendedActor(
      id: parsedJson['id'],
      image: parsedJson['image'],
    );
  }
}