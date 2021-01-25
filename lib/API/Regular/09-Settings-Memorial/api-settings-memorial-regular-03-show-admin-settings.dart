import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowAdminsSettingMain> apiRegularShowAdminSettings({int memorialId, int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  APIRegularShowAdminsSettingMain returnValue;

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
      returnValue = APIRegularShowAdminsSettingMain.fromJson(newValue);
    }
  }catch(e){
    throw Exception('$e');
  }

  return returnValue;
}



class APIRegularShowAdminsSettingMain{
  int adminItemsRemaining;
  int familyItemsRemaining;
  List<APIRegularShowAdminsSettingExtended> adminList;
  List<APIRegularShowAdminsSettingExtended> familyList;

  APIRegularShowAdminsSettingMain({this.adminItemsRemaining, this.familyItemsRemaining, this.adminList, this.familyList});

  factory APIRegularShowAdminsSettingMain.fromJson(Map<String, dynamic> parsedJson){

    var adminList = parsedJson['admins'] as List;
    var familyList = parsedJson['family'] as List;

    List<APIRegularShowAdminsSettingExtended> newList1 = adminList.map((i) => APIRegularShowAdminsSettingExtended.fromJson(i)).toList();
    List<APIRegularShowAdminsSettingExtended> newList2 = familyList.map((i) => APIRegularShowAdminsSettingExtended.fromJson(i)).toList();

    return APIRegularShowAdminsSettingMain(
      adminItemsRemaining: parsedJson['adminsitemsremaining'],
      familyItemsRemaining: parsedJson['familyitemsremaining'],
      adminList: newList1,
      familyList: newList2,
    );
  }
}

class APIRegularShowAdminsSettingExtended{

  APIRegularShowAdminsSettingExtendedUser user;
  String relationship;

  APIRegularShowAdminsSettingExtended({this.user, this.relationship});

  factory APIRegularShowAdminsSettingExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowAdminsSettingExtended(
      user: APIRegularShowAdminsSettingExtendedUser.fromJson(parsedJson['user']),
      relationship: parsedJson['relationship']
    );
  }
}

class APIRegularShowAdminsSettingExtendedUser{
  int id;
  String firstName;
  String lastName;
  dynamic image;
  String email;

  APIRegularShowAdminsSettingExtendedUser({this.id, this.firstName, this.lastName, this.image, this.email});

  factory APIRegularShowAdminsSettingExtendedUser.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowAdminsSettingExtendedUser(
      id: parsedJson['id'],
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      image: parsedJson['image'],
      email: parsedJson['email'],
    );
  }
}
