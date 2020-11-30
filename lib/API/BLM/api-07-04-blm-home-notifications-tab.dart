import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMHomeTabNotificationMain> apiBLMHomeNotificationsTab() async{

  final sharedPrefs = await SharedPreferences.getInstance();
  var getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  var getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  var getClient = sharedPrefs.getString('blm-client') ?? 'empty';
  
  final http.Response response = await http.get(
    'http://fbp.dev1.koda.ws/api/v1/mainpages/notifications/?page=1',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The response status in blm notification is ${response.statusCode}');
  print('The response status in blm notification is ${response.body}');


  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMHomeTabNotificationMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the notifications');
  }
}


class APIBLMHomeTabNotificationMain{

  List<APIBLMHomeTabNotificationExtended> notification;

  APIBLMHomeTabNotificationMain({this.notification});

  factory APIBLMHomeTabNotificationMain.fromJson(List<dynamic> parsedJson){
    List<APIBLMHomeTabNotificationExtended> newNotification = parsedJson.map((e) => APIBLMHomeTabNotificationExtended.fromJson(e)).toList();

    return APIBLMHomeTabNotificationMain(
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