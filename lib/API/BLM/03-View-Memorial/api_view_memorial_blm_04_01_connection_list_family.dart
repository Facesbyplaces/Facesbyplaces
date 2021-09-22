import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIBLMConnectionListFamilyMain> apiBLMConnectionListFamily({required int memorialId, required int page}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  bool userSessionRegular = sharedPrefs.getBool('regular-user-session') ?? false;
  bool userSessionBLM = sharedPrefs.getBool('blm-user-session') ?? false;
  String? getAccessToken;
  String? getUID;
  String? getClient;

  if(userSessionRegular == true){
    getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
    getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
    getClient = sharedPrefs.getString('regular-client') ?? 'empty';
  }else if(userSessionBLM == true){
    getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
    getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
    getClient = sharedPrefs.getString('blm-client') ?? 'empty';
  }

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://facesbyplaces.com/api/v1/pages/blm/$memorialId/family/index?page=$page',
    options: Options(
      followRedirects: false,
      validateStatus: (status){
        return status! < 600;
      },
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIBLMConnectionListFamilyMain.fromJson(newData);
  }else{
    throw Exception('Failed to show list of family members');
  }
}

class APIBLMConnectionListFamilyMain{
  int blmItemsRemaining;
  List<APIBLMConnectionListFamilyExtended> blmFamilyList;
  APIBLMConnectionListFamilyMain({required this.blmItemsRemaining, required this.blmFamilyList});

  factory APIBLMConnectionListFamilyMain.fromJson(Map<String, dynamic> parsedJson){
    var newList1 = parsedJson['family'] as List;
    List<APIBLMConnectionListFamilyExtended> familyList = newList1.map((i) => APIBLMConnectionListFamilyExtended.fromJson(i)).toList();

    return APIBLMConnectionListFamilyMain(
      blmItemsRemaining: parsedJson['itemsremaining'],
      blmFamilyList: familyList,
    );
  }
}

class APIBLMConnectionListFamilyExtended{
  APIBLMConnectionListFamilyExtendedDetails connectionListFamilyUser;
  String connectionListFamilyRelationship;
  APIBLMConnectionListFamilyExtended({required this.connectionListFamilyUser, required this.connectionListFamilyRelationship});

  factory APIBLMConnectionListFamilyExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMConnectionListFamilyExtended(
      connectionListFamilyUser: APIBLMConnectionListFamilyExtendedDetails.fromJson(parsedJson['user']),
      connectionListFamilyRelationship: parsedJson['relationship'] ?? '',
    );
  }
}

class APIBLMConnectionListFamilyExtendedDetails{
  int connectionListFamilyDetailsId;
  String connectionListFamilyDetailsFirstName;
  String connectionListFamilyDetailsLastName;
  String connectionListFamilyDetailsImage;
  int connectionListFamilyAccountType;
  APIBLMConnectionListFamilyExtendedDetails({required this.connectionListFamilyDetailsId, required this.connectionListFamilyDetailsFirstName, required this.connectionListFamilyDetailsLastName, required this.connectionListFamilyDetailsImage, required this.connectionListFamilyAccountType});

  factory APIBLMConnectionListFamilyExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMConnectionListFamilyExtendedDetails(
      connectionListFamilyDetailsId: parsedJson['id'],
      connectionListFamilyDetailsFirstName: parsedJson['first_name'] ?? '',
      connectionListFamilyDetailsLastName: parsedJson['last_name'] ?? '',
      connectionListFamilyDetailsImage: parsedJson['image'] ?? '',
      connectionListFamilyAccountType: parsedJson['account_type'],
    );
  }
}