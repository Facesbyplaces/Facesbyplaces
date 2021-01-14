import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowFriendsSettingsMain> apiRegularShowFriendsSettings({int memorialId, int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  APIRegularShowFriendsSettingsMain returnValue;

  try{
    final http.Response response = await http.get(
      'http://fbp.dev1.koda.ws/api/v1/pages/memorials/$memorialId/friends/index?page=$page',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    );

    if(response.statusCode == 200){
      var newValue = json.decode(response.body);
      return APIRegularShowFriendsSettingsMain.fromJson(newValue);
    }
  }catch(e){
    throw Exception('$e');
  }

  return returnValue;
}

class APIRegularShowFriendsSettingsMain{
  int itemsRemaining;
  List<APIRegularShowFriendsSettingsExtended> friendsList;

  APIRegularShowFriendsSettingsMain({this.itemsRemaining, this.friendsList});

  factory APIRegularShowFriendsSettingsMain.fromJson(Map<String, dynamic> parsedJson){

    var newList1 = parsedJson['friends'] as List;
    List<APIRegularShowFriendsSettingsExtended> familyList = newList1.map((i) => APIRegularShowFriendsSettingsExtended.fromJson(i)).toList();

    return APIRegularShowFriendsSettingsMain(
      itemsRemaining: parsedJson['itemsremaining'],
      friendsList: familyList,
    );
  }
}


class APIRegularShowFriendsSettingsExtended{
  APIRegularShowFriendsSettingsExtendedDetails user;
  String relationship;

  APIRegularShowFriendsSettingsExtended({this.user, this.relationship});

  factory APIRegularShowFriendsSettingsExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowFriendsSettingsExtended(
      user: APIRegularShowFriendsSettingsExtendedDetails.fromJson(parsedJson['user']),
      relationship: parsedJson['relationship'],
    );
  }
}

class APIRegularShowFriendsSettingsExtendedDetails{

  int id;
  String firstName;
  String lastName;
  dynamic image;
  String email;

  APIRegularShowFriendsSettingsExtendedDetails({this.id, this.firstName, this.lastName, this.image, this.email});

  factory APIRegularShowFriendsSettingsExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowFriendsSettingsExtendedDetails(
      id: parsedJson['id'],
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      image: parsedJson['image'],
      email: parsedJson['email'],
    );
  }
}
