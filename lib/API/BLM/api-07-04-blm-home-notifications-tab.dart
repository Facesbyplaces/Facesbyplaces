import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMHomeTabNotificationMain> apiBLMHomeNotificationsTab(int page) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  var getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  var getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  var getClient = sharedPrefs.getString('blm-client') ?? 'empty';
  
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
  int actorId;
  bool read;
  String action;
  String url;

  APIBLMHomeTabNotificationExtended({this.id, this.createdAt, this.updatedAt, this.recipientId, this.actorId, this.read, this.action, this.url});

  factory APIBLMHomeTabNotificationExtended.fromJson(Map<String, dynamic> parsedJson){

    return APIBLMHomeTabNotificationExtended(
      id: parsedJson['id'],
      createdAt: parsedJson['created_at'],
      updatedAt: parsedJson['updated_at'],
      recipientId: parsedJson['recipient_id'],
      actorId: parsedJson['actor_id'],
      read: parsedJson['read'],
      action: parsedJson['action'],
      url: parsedJson['url'],
    );
  }
}