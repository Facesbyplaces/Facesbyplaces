import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowFriendsSettingsMain> apiBLMShowFriendsSettings({int memorialId, int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/pages/blm/$memorialId/friends/index?page=$page',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMShowFriendsSettingsMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the lists.');
  }
}

class APIBLMShowFriendsSettingsMain{
  int itemsRemaining;
  List<APIBLMShowFriendsSettingsExtended> friendsList;

  APIBLMShowFriendsSettingsMain({this.itemsRemaining, this.friendsList});

  factory APIBLMShowFriendsSettingsMain.fromJson(Map<String, dynamic> parsedJson){

    var newList1 = parsedJson['friends'] as List;
    List<APIBLMShowFriendsSettingsExtended> familyList = newList1.map((i) => APIBLMShowFriendsSettingsExtended.fromJson(i)).toList();

    return APIBLMShowFriendsSettingsMain(
      itemsRemaining: parsedJson['itemsremaining'],
      friendsList: familyList,
    );
  }
}


class APIBLMShowFriendsSettingsExtended{
  APIBLMShowFriendsSettingsExtendedDetails user;
  String relationship;

  APIBLMShowFriendsSettingsExtended({this.user, this.relationship});

  factory APIBLMShowFriendsSettingsExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowFriendsSettingsExtended(
      user: APIBLMShowFriendsSettingsExtendedDetails.fromJson(parsedJson['user']),
      relationship: parsedJson['relationship'],
    );
  }
}

class APIBLMShowFriendsSettingsExtendedDetails{

  int id;
  String firstName;
  String lastName;
  dynamic image;
  String email;
  int accountType;

  APIBLMShowFriendsSettingsExtendedDetails({this.id, this.firstName, this.lastName, this.image, this.email, this.accountType});

  factory APIBLMShowFriendsSettingsExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowFriendsSettingsExtendedDetails(
      id: parsedJson['id'],
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      image: parsedJson['image'],
      email: parsedJson['email'],
      accountType: parsedJson['account_type'],
    );
  }
}
