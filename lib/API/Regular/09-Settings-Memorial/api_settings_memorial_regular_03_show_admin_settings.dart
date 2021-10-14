import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularShowAdminsSettingsMain> apiRegularShowAdminSettings({required int memorialId, required int page}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('https://facesbyplaces.com/api/v1/pages/memorials/adminIndex/index?page=$page&page_id=$memorialId',
    options: Options(
      followRedirects: false,
      validateStatus: (status){
        return status! < 600;
      },
      headers: <String, dynamic>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),
  );

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIRegularShowAdminsSettingsMain.fromJson(newData);
  }else{
    throw Exception('Error occurred: ${response.statusMessage}');
  }
}

class APIRegularShowAdminsSettingsMain{
  int almAdminItemsRemaining;
  int almFamilyItemsRemaining;
  List<APIRegularShowAdminsSettingsExtended> almAdminList;
  List<APIRegularShowAdminsSettingsExtended> almFamilyList;
  APIRegularShowAdminsSettingsMain({required this.almAdminItemsRemaining, required this.almFamilyItemsRemaining, required this.almAdminList, required this.almFamilyList});

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
  APIRegularShowAdminsSettingsExtended({required this.showAdminsSettingsUser, required this.showAdminsSettingsRelationship});

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
  String showAdminsSettingsUserImage;
  String showAdminsSettingsUserEmail;
  APIRegularShowAdminsSettingsExtendedUser({required this.showAdminsSettingsUserId, required this.showAdminsSettingsUserFirstName, required this.showAdminsSettingsUserLastName, required this.showAdminsSettingsUserImage, required this.showAdminsSettingsUserEmail});

  factory APIRegularShowAdminsSettingsExtendedUser.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowAdminsSettingsExtendedUser(
      showAdminsSettingsUserId: parsedJson['id'],
      showAdminsSettingsUserFirstName: parsedJson['first_name'] ?? '',
      showAdminsSettingsUserLastName: parsedJson['last_name'] ?? '',
      showAdminsSettingsUserImage: parsedJson['image'] ?? '',
      showAdminsSettingsUserEmail: parsedJson['email'] ?? '',
    );
  }
}