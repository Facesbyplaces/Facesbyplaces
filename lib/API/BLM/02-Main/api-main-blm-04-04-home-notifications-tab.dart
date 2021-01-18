import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMHomeTabNotificationMain> apiBLMHomeNotificationsTab({int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';
  
  final http.Response response = await http.get(
    'http://fbp.dev1.koda.ws/api/v1/mainpages/notifications/?page=$page',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The response status code of notifications is ${response.statusCode}');
  print('The response status bofy of notifications is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMHomeTabNotificationMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the notifications');
  }
}


class APIBLMHomeTabNotificationMain{
  int itemsRemaining;
  List<APIBLMHomeTabNotificationExtended> notification;

  APIBLMHomeTabNotificationMain({this.itemsRemaining, this.notification});

  factory APIBLMHomeTabNotificationMain.fromJson(Map<String, dynamic> parsedJson){

    var newList = parsedJson['notifs'] as List;
    List<APIBLMHomeTabNotificationExtended> newNotification = newList.map((i) => APIBLMHomeTabNotificationExtended.fromJson(i)).toList();

    return APIBLMHomeTabNotificationMain(
      itemsRemaining: parsedJson['itemsremaining'],
      notification: newNotification,
    );
  }
}


class APIBLMHomeTabNotificationExtended{
  int id;
  String createdAt;
  String updatedAt;
  int recipientId;
  APIBLMHomeTabNotificationExtendedActor actor;
  bool read;
  String action;
  int postId;

  APIBLMHomeTabNotificationExtended({this.id, this.createdAt, this.updatedAt, this.recipientId, this.actor, this.read, this.action, this.postId});

  factory APIBLMHomeTabNotificationExtended.fromJson(Map<String, dynamic> parsedJson){

    return APIBLMHomeTabNotificationExtended(
      id: parsedJson['id'],
      createdAt: parsedJson['created_at'],
      updatedAt: parsedJson['updated_at'],
      recipientId: parsedJson['recipient_id'],
      actor: APIBLMHomeTabNotificationExtendedActor.fromJson(parsedJson['actor']),
      read: parsedJson['read'],
      action: parsedJson['action'],
      postId: parsedJson['postId'],
    );
  }
}



class APIBLMHomeTabNotificationExtendedActor{
  int id;
  String image;

  APIBLMHomeTabNotificationExtendedActor({this.id, this.image});

  factory APIBLMHomeTabNotificationExtendedActor.fromJson(Map<String, dynamic> parsedJson){

    return APIBLMHomeTabNotificationExtendedActor(
      id: parsedJson['id'],
      image: parsedJson['image'],
    );
  }
}