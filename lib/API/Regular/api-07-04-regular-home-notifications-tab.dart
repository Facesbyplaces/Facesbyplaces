import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularHomeTabNotificationMain> apiRegularHomeNotificationsTab() async{

  final sharedPrefs = await SharedPreferences.getInstance();
  var getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  var getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  var getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get(
    'http://fbp.dev1.koda.ws/api/v1/mainpages/notifications/?page=1',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The response status in notifications is ${response.statusCode}');
  print('The response status in notifications is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularHomeTabNotificationMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the notifications');
  }
}


class APIRegularHomeTabNotificationMain{

  List<APIRegularHomeTabNotificationExtended> notification;

  APIRegularHomeTabNotificationMain({this.notification});

  factory APIRegularHomeTabNotificationMain.fromJson(Map<String, dynamic>  parsedJson){
    var newList = parsedJson['notifs'] as List;
    List<APIRegularHomeTabNotificationExtended> newNotification = newList.map((i) => APIRegularHomeTabNotificationExtended.fromJson(i)).toList();

    return APIRegularHomeTabNotificationMain(
      notification: newNotification,
    );
  }
}


class APIRegularHomeTabNotificationExtended{
  int id;
  String createdAt;
  String updatedAt;
  int recipientId;
  int actorId;
  bool read;
  String action;
  String url;

  APIRegularHomeTabNotificationExtended({this.id, this.createdAt, this.updatedAt, this.recipientId, this.actorId, this.read, this.action, this.url});

  factory APIRegularHomeTabNotificationExtended.fromJson(Map<String, dynamic> parsedJson){

    return APIRegularHomeTabNotificationExtended(
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