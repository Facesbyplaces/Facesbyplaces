import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIBLMShowAdminsSettingMain> apiBLMShowAdminSettings({required int memorialId, required int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/pages/blm/adminIndex/index?page=$page&page_id=$memorialId',
    options: Options(
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  print('The status code of blm show admin settings is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIBLMShowAdminsSettingMain.fromJson(newData);
  }else{
    throw Exception('Failed to get the admin settings.');
  }
}

class APIBLMShowAdminsSettingMain{
  int blmAdminItemsRemaining;
  int blmFamilyItemsRemaining;
  List<APIBLMShowAdminsSettingExtended> blmAdminList;
  List<APIBLMShowAdminsSettingExtended> blmFamilyList;

  APIBLMShowAdminsSettingMain({required this.blmAdminItemsRemaining, required this.blmFamilyItemsRemaining, required this.blmAdminList, required this.blmFamilyList});

  factory APIBLMShowAdminsSettingMain.fromJson(Map<String, dynamic> parsedJson){

    var adminList = parsedJson['admins'] as List;
    var familyList = parsedJson['family'] as List;

    List<APIBLMShowAdminsSettingExtended> newList1 = adminList.map((i) => APIBLMShowAdminsSettingExtended.fromJson(i)).toList();
    List<APIBLMShowAdminsSettingExtended> newList2 = familyList.map((i) => APIBLMShowAdminsSettingExtended.fromJson(i)).toList();

    return APIBLMShowAdminsSettingMain(
      blmAdminItemsRemaining: parsedJson['adminsitemsremaining'],
      blmFamilyItemsRemaining: parsedJson['familyitemsremaining'],
      blmAdminList: newList1,
      blmFamilyList: newList2,
    );
  }
}

class APIBLMShowAdminsSettingExtended{

  APIBLMShowAdminsSettingExtendedUser showAdminsSettingsUser;
  String showAdminsSettingsRelationship;

  APIBLMShowAdminsSettingExtended({required this.showAdminsSettingsUser, required this.showAdminsSettingsRelationship});

  factory APIBLMShowAdminsSettingExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowAdminsSettingExtended(
      showAdminsSettingsUser: APIBLMShowAdminsSettingExtendedUser.fromJson(parsedJson['user']),
      showAdminsSettingsRelationship: parsedJson['relationship'] != null ? parsedJson['relationship'] : '',
    );
  }
}

class APIBLMShowAdminsSettingExtendedUser{
  String showAdminsSettingsUserFirstName;
  String showAdminsSettingsUserLastName;
  String showAdminsSettingsUserImage;
  String showAdminsSettingsUserEmail;

  APIBLMShowAdminsSettingExtendedUser({required this.showAdminsSettingsUserFirstName, required this.showAdminsSettingsUserLastName, required this.showAdminsSettingsUserImage, required this.showAdminsSettingsUserEmail});

  factory APIBLMShowAdminsSettingExtendedUser.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowAdminsSettingExtendedUser(
      showAdminsSettingsUserFirstName: parsedJson['first_name'] != null ? parsedJson['first_name'] : '',
      showAdminsSettingsUserLastName: parsedJson['last_name'] != null ? parsedJson['last_name'] : '',
      showAdminsSettingsUserImage: parsedJson['image'] != null ? parsedJson['image'] : '',
      showAdminsSettingsUserEmail: parsedJson['email'] != null ? parsedJson['email'] : '',
    );
  }
}