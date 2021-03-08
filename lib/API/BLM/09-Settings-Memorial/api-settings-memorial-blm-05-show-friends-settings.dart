import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowFriendsSettingsMain> apiBLMShowFriendsSettings({required int memorialId, required int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get(
    Uri.http('http://fbp.dev1.koda.ws/api/v1/pages/blm/$memorialId/friends/index?page=$page', ''),
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
  int blmItemsRemaining;
  List<APIBLMShowFriendsSettingsExtended> blmFriendsList;

  APIBLMShowFriendsSettingsMain({required this.blmItemsRemaining, required this.blmFriendsList});

  factory APIBLMShowFriendsSettingsMain.fromJson(Map<String, dynamic> parsedJson){

    var newList1 = parsedJson['friends'] as List;
    List<APIBLMShowFriendsSettingsExtended> familyList = newList1.map((i) => APIBLMShowFriendsSettingsExtended.fromJson(i)).toList();

    return APIBLMShowFriendsSettingsMain(
      blmItemsRemaining: parsedJson['itemsremaining'],
      blmFriendsList: familyList,
    );
  }
}

class APIBLMShowFriendsSettingsExtended{
  APIBLMShowFriendsSettingsExtendedDetails showFriendsSettingsUser;
  String showFriendsSettingsRelationship;

  APIBLMShowFriendsSettingsExtended({required this.showFriendsSettingsUser, required this.showFriendsSettingsRelationship});

  factory APIBLMShowFriendsSettingsExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowFriendsSettingsExtended(
      showFriendsSettingsUser: APIBLMShowFriendsSettingsExtendedDetails.fromJson(parsedJson['user']),
      showFriendsSettingsRelationship: parsedJson['relationship'],
    );
  }
}

class APIBLMShowFriendsSettingsExtendedDetails{

  int showFriendsSettingsDetailsId;
  String showFriendsSettingsDetailsFirstName;
  String showFriendsSettingsDetailsLastName;
  dynamic showFriendsSettingsDetailsImage;
  String showFriendsSettingsDetailsEmail;
  int showFriendsSettingsDetailsAccountType;

  APIBLMShowFriendsSettingsExtendedDetails({required this.showFriendsSettingsDetailsId, required this.showFriendsSettingsDetailsFirstName, required this.showFriendsSettingsDetailsLastName, required this.showFriendsSettingsDetailsImage, required this.showFriendsSettingsDetailsEmail, required this.showFriendsSettingsDetailsAccountType});

  factory APIBLMShowFriendsSettingsExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowFriendsSettingsExtendedDetails(
      showFriendsSettingsDetailsId: parsedJson['id'],
      showFriendsSettingsDetailsFirstName: parsedJson['first_name'],
      showFriendsSettingsDetailsLastName: parsedJson['last_name'],
      showFriendsSettingsDetailsImage: parsedJson['image'],
      showFriendsSettingsDetailsEmail: parsedJson['email'],
      showFriendsSettingsDetailsAccountType: parsedJson['account_type'],
    );
  }
}
