import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowAdminsSettingMain> apiBLMShowAdminSettings({int memorialId, int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/pages/blm/adminIndex/index?page=$page&page_id=$memorialId',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMShowAdminsSettingMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the lists.');
  }
}

class APIBLMShowAdminsSettingMain{
  int adminItemsRemaining;
  int familyItemsRemaining;
  List<APIBLMShowAdminsSettingExtended> adminList;
  List<APIBLMShowAdminsSettingExtended> familyList;

  APIBLMShowAdminsSettingMain({this.adminItemsRemaining, this.familyItemsRemaining, this.adminList, this.familyList});

  factory APIBLMShowAdminsSettingMain.fromJson(Map<String, dynamic> parsedJson){

    var adminList = parsedJson['admins'] as List;
    var familyList = parsedJson['family'] as List;

    List<APIBLMShowAdminsSettingExtended> newList1 = adminList.map((i) => APIBLMShowAdminsSettingExtended.fromJson(i)).toList();
    List<APIBLMShowAdminsSettingExtended> newList2 = familyList.map((i) => APIBLMShowAdminsSettingExtended.fromJson(i)).toList();

    return APIBLMShowAdminsSettingMain(
      adminItemsRemaining: parsedJson['adminsitemsremaining'],
      familyItemsRemaining: parsedJson['familyitemsremaining'],
      adminList: newList1,
      familyList: newList2,
    );
  }
}

class APIBLMShowAdminsSettingExtended{

  APIBLMShowAdminsSettingExtendedUser user;
  String relationship;

  APIBLMShowAdminsSettingExtended({this.user, this.relationship});

  factory APIBLMShowAdminsSettingExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowAdminsSettingExtended(
      user: APIBLMShowAdminsSettingExtendedUser.fromJson(parsedJson['user']),
      relationship: parsedJson['relationship']
    );
  }
}

class APIBLMShowAdminsSettingExtendedUser{
  int id;
  String firstName;
  String lastName;
  dynamic image;
  String email;

  APIBLMShowAdminsSettingExtendedUser({this.id, this.firstName, this.lastName, this.image, this.email});

  factory APIBLMShowAdminsSettingExtendedUser.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowAdminsSettingExtendedUser(
      id: parsedJson['id'],
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      image: parsedJson['image'],
      email: parsedJson['email'],
    );
  }
}
