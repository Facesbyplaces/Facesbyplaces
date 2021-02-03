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
    final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/pages/memorials/$memorialId/friends/index?page=$page',
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
  int almItemsRemaining;
  List<APIRegularShowFriendsSettingsExtended> almFriendsList;

  APIRegularShowFriendsSettingsMain({this.almItemsRemaining, this.almFriendsList});

  factory APIRegularShowFriendsSettingsMain.fromJson(Map<String, dynamic> parsedJson){

    var newList1 = parsedJson['friends'] as List;
    List<APIRegularShowFriendsSettingsExtended> familyList = newList1.map((i) => APIRegularShowFriendsSettingsExtended.fromJson(i)).toList();

    return APIRegularShowFriendsSettingsMain(
      almItemsRemaining: parsedJson['itemsremaining'],
      almFriendsList: familyList,
    );
  }
}


class APIRegularShowFriendsSettingsExtended{
  APIRegularShowFriendsSettingsExtendedDetails showFriendsSettingsUser;
  String showFriendsSettingsRelationship;

  APIRegularShowFriendsSettingsExtended({this.showFriendsSettingsUser, this.showFriendsSettingsRelationship});

  factory APIRegularShowFriendsSettingsExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowFriendsSettingsExtended(
      showFriendsSettingsUser: APIRegularShowFriendsSettingsExtendedDetails.fromJson(parsedJson['user']),
      showFriendsSettingsRelationship: parsedJson['relationship'],
    );
  }
}

class APIRegularShowFriendsSettingsExtendedDetails{

  int showFriendsSettingsDetailsId;
  String showFriendsSettingsDetailsFirstName;
  String showFriendsSettingsDetailsLastName;
  dynamic showFriendsSettingsDetailsImage;
  String showFriendsSettingsDetailsEmail;
  int showFriendsSettingsDetailsAccountType;

  APIRegularShowFriendsSettingsExtendedDetails({this.showFriendsSettingsDetailsId, this.showFriendsSettingsDetailsFirstName, this.showFriendsSettingsDetailsLastName, this.showFriendsSettingsDetailsImage, this.showFriendsSettingsDetailsEmail, this.showFriendsSettingsDetailsAccountType});

  factory APIRegularShowFriendsSettingsExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowFriendsSettingsExtendedDetails(
      showFriendsSettingsDetailsId: parsedJson['id'],
      showFriendsSettingsDetailsFirstName: parsedJson['first_name'],
      showFriendsSettingsDetailsLastName: parsedJson['last_name'],
      showFriendsSettingsDetailsImage: parsedJson['image'],
      showFriendsSettingsDetailsEmail: parsedJson['email'],
      showFriendsSettingsDetailsAccountType: parsedJson['account_type'],
    );
  }
}
