import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowAdminsSettingsMain> apiRegularShowAdminSettings({int memorialId, int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  APIRegularShowAdminsSettingsMain returnValue;

  try{
    final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/pages/memorials/adminIndex/index?page=$page&page_id=$memorialId',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    );

    if(response.statusCode == 200){
      var newValue = json.decode(response.body);
      returnValue = APIRegularShowAdminsSettingsMain.fromJson(newValue);
    }
  }catch(e){
    throw Exception('$e');
  }

  return returnValue;
}

class APIRegularShowAdminsSettingsMain{
  int almAdminItemsRemaining;
  int almFamilyItemsRemaining;
  List<APIRegularShowAdminsSettingsExtended> almAdminList;
  List<APIRegularShowAdminsSettingsExtended> almFamilyList;

  APIRegularShowAdminsSettingsMain({this.almAdminItemsRemaining, this.almFamilyItemsRemaining, this.almAdminList, this.almFamilyList});

  factory APIRegularShowAdminsSettingsMain.fromJson(Map<String, dynamic> parsedJson){

    var adminList = parsedJson['admins'] as List;
    var familyList = parsedJson['family'] as List;

    List<APIRegularShowAdminsSettingsExtended> newList1 = adminList.map((i) => APIRegularShowAdminsSettingsExtended.fromJson(i)).toList();
    List<APIRegularShowAdminsSettingsExtended> newList2 = familyList.map((i) => APIRegularShowAdminsSettingsExtended.fromJson(i)).toList();

    return APIRegularShowAdminsSettingsMain(
      almAdminItemsRemaining: parsedJson['adminsitemsremaining'],
      almFamilyItemsRemaining: parsedJson['familyitemsremaining'],
      almAdminList: newList1,
      almFamilyList: newList2,
    );
  }
}

class APIRegularShowAdminsSettingsExtended{

  APIRegularShowAdminsSettingsExtendedUser showAdminsSettingsUser;
  String showAdminsSettingsRelationship;

  APIRegularShowAdminsSettingsExtended({this.showAdminsSettingsUser, this.showAdminsSettingsRelationship});

  factory APIRegularShowAdminsSettingsExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowAdminsSettingsExtended(
      showAdminsSettingsUser: APIRegularShowAdminsSettingsExtendedUser.fromJson(parsedJson['user']),
      showAdminsSettingsRelationship: parsedJson['relationship']
    );
  }
}

class APIRegularShowAdminsSettingsExtendedUser{
  int showAdminsSettingsUserId;
  String showAdminsSettingsUserFirstName;
  String showAdminsSettingsUserLastName;
  dynamic showAdminsSettingsUserImage;
  String showAdminsSettingsUserEmail;

  APIRegularShowAdminsSettingsExtendedUser({this.showAdminsSettingsUserId, this.showAdminsSettingsUserFirstName, this.showAdminsSettingsUserLastName, this.showAdminsSettingsUserImage, this.showAdminsSettingsUserEmail});

  factory APIRegularShowAdminsSettingsExtendedUser.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowAdminsSettingsExtendedUser(
      showAdminsSettingsUserId: parsedJson['id'],
      showAdminsSettingsUserFirstName: parsedJson['first_name'],
      showAdminsSettingsUserLastName: parsedJson['last_name'],
      showAdminsSettingsUserImage: parsedJson['image'],
      showAdminsSettingsUserEmail: parsedJson['email'],
    );
  }
}
