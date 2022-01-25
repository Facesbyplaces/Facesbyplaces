import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIBLMShowAdminsSettingsMain> apiBLMShowAdminSettings({required int memorialId, required int page}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('https://www.facesbyplaces.com/api/v1/pages/blm/adminIndex/index?page=$page&page_id=$memorialId',
    options: Options(
      headers: <String, dynamic>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      },
      validateStatus: (status){
        return status! < 600;
      },
      followRedirects: false,
    ),  
  );

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIBLMShowAdminsSettingsMain.fromJson(newData);
  }else{
    throw Exception('Failed to get the admin settings.');
  }
}

class APIBLMShowAdminsSettingsMain{
  int blmAdminItemsRemaining;
  int blmFamilyItemsRemaining;
  List<APIBLMShowAdminsSettingExtended> blmAdminList;
  List<APIBLMShowAdminsSettingExtended> blmFamilyList;
  APIBLMShowAdminsSettingsMain({required this.blmAdminItemsRemaining, required this.blmFamilyItemsRemaining, required this.blmAdminList, required this.blmFamilyList});

  factory APIBLMShowAdminsSettingsMain.fromJson(Map<String, dynamic> parsedJson){
    var adminList = parsedJson['admins'] as List;
    var familyList = parsedJson['family'] as List;

    List<APIBLMShowAdminsSettingExtended> newList1 = adminList.map((i) => APIBLMShowAdminsSettingExtended.fromJson(i)).toList();
    List<APIBLMShowAdminsSettingExtended> newList2 = familyList.map((i) => APIBLMShowAdminsSettingExtended.fromJson(i)).toList();

    return APIBLMShowAdminsSettingsMain(
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
  bool showAdminsSettingsPageOwner;
  APIBLMShowAdminsSettingExtended({required this.showAdminsSettingsUser, required this.showAdminsSettingsRelationship, required this.showAdminsSettingsPageOwner});

  factory APIBLMShowAdminsSettingExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowAdminsSettingExtended(
      showAdminsSettingsUser: APIBLMShowAdminsSettingExtendedUser.fromJson(parsedJson['user']),
      showAdminsSettingsRelationship: parsedJson['relationship'] ?? '',
      showAdminsSettingsPageOwner: parsedJson['pageowner'] ?? false,
    );
  }
}

class APIBLMShowAdminsSettingExtendedUser{
  int showAdminsSettingsUserId;
  String showAdminsSettingsUserFirstName;
  String showAdminsSettingsUserLastName;
  String showAdminsSettingsUserImage;
  String showAdminsSettingsUserEmail;
  APIBLMShowAdminsSettingExtendedUser({required this.showAdminsSettingsUserId, required this.showAdminsSettingsUserFirstName, required this.showAdminsSettingsUserLastName, required this.showAdminsSettingsUserImage, required this.showAdminsSettingsUserEmail});

  factory APIBLMShowAdminsSettingExtendedUser.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowAdminsSettingExtendedUser(
      showAdminsSettingsUserId: parsedJson['id'],
      showAdminsSettingsUserFirstName: parsedJson['first_name'] ?? '',
      showAdminsSettingsUserLastName: parsedJson['last_name'] ?? '',
      showAdminsSettingsUserImage: parsedJson['image'] ?? '',
      showAdminsSettingsUserEmail: parsedJson['email'] ?? '',
    );
  }
}