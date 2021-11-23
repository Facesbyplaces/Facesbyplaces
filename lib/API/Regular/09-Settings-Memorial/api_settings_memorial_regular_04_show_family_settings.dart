import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularShowFamilySettingsMain> apiRegularShowFamilySettings({required int memorialId, required int page}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';
  
  Dio dioRequest = Dio();

  var response = await dioRequest.get('https://www.facesbyplaces.com/api/v1/pages/memorials/$memorialId/family/index?page=$page',
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
    return APIRegularShowFamilySettingsMain.fromJson(newData);
  }else{
    throw Exception('Error occurred: ${response.statusMessage}');
  }
}

class APIRegularShowFamilySettingsMain{
  int almItemsRemaining;
  List<APIRegularShowFamilySettingsExtended> almFamilyList;
  APIRegularShowFamilySettingsMain({required this.almItemsRemaining, required this.almFamilyList});

  factory APIRegularShowFamilySettingsMain.fromJson(Map<String, dynamic> parsedJson){
    var newList1 = parsedJson['family'] as List;
    List<APIRegularShowFamilySettingsExtended> familyList = newList1.map((i) => APIRegularShowFamilySettingsExtended.fromJson(i)).toList();

    return APIRegularShowFamilySettingsMain(
      almItemsRemaining: parsedJson['itemsremaining'],
      almFamilyList: familyList,
    );
  }
}


class APIRegularShowFamilySettingsExtended{
  APIRegularShowFamilySettingsExtendedDetails showFamilySettingsUser;
  String showFamilySettingsRelationship;
  bool showFamilySettingsPageOwner;
  APIRegularShowFamilySettingsExtended({required this.showFamilySettingsUser, required this.showFamilySettingsRelationship, required this.showFamilySettingsPageOwner});

  factory APIRegularShowFamilySettingsExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowFamilySettingsExtended(
      showFamilySettingsUser: APIRegularShowFamilySettingsExtendedDetails.fromJson(parsedJson['user']),
      showFamilySettingsRelationship: parsedJson['relationship'],
      showFamilySettingsPageOwner: parsedJson['pageowner'],
    );
  }
}

class APIRegularShowFamilySettingsExtendedDetails{
  int showFamilySettingsDetailsId;
  String showFamilySettingsDetailsFirstName;
  String showFamilySettingsDetailsLastName;
  String showFamilySettingsDetailsImage;
  String showFamilySettingsDetailsEmail;
  int showFamilySettingsDetailsAccountType;
  APIRegularShowFamilySettingsExtendedDetails({required this.showFamilySettingsDetailsId, required this.showFamilySettingsDetailsFirstName, required this.showFamilySettingsDetailsLastName, required this.showFamilySettingsDetailsImage, required this.showFamilySettingsDetailsEmail, required this.showFamilySettingsDetailsAccountType});

  factory APIRegularShowFamilySettingsExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowFamilySettingsExtendedDetails(
      showFamilySettingsDetailsId: parsedJson['id'],
      showFamilySettingsDetailsFirstName: parsedJson['first_name'] ?? '',
      showFamilySettingsDetailsLastName: parsedJson['last_name'] ?? '',
      showFamilySettingsDetailsImage: parsedJson['image'] ?? '',
      showFamilySettingsDetailsEmail: parsedJson['email'] ?? '',
      showFamilySettingsDetailsAccountType: parsedJson['account_type'],
    );
  }
}