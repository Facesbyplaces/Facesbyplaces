import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularConnectionListFamilyMain> apiRegularConnectionListFamily({required int memorialId, required int page}) async{
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

  var response = await dioRequest.get('http://facesbyplaces.com/api/v1/pages/memorials/$memorialId/family/index?page=$page',
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
    return APIRegularConnectionListFamilyMain.fromJson(newData);
  }else{
    throw Exception('Failed to show the connection list family.');
  }
}

class APIRegularConnectionListFamilyMain{
  int almItemsRemaining;
  List<APIRegularConnectionListFamilyExtended> almFamilyList;
  APIRegularConnectionListFamilyMain({required this.almItemsRemaining, required this.almFamilyList});

  factory APIRegularConnectionListFamilyMain.fromJson(Map<String, dynamic> parsedJson){
    var newList1 = parsedJson['family'] as List;
    List<APIRegularConnectionListFamilyExtended> familyList = newList1.map((i) => APIRegularConnectionListFamilyExtended.fromJson(i)).toList();

    return APIRegularConnectionListFamilyMain(
      almItemsRemaining: parsedJson['itemsremaining'],
      almFamilyList: familyList,
    );
  }
}

class APIRegularConnectionListFamilyExtended{
  APIRegularConnectionListFamilyExtendedDetails connectionListFamilyUser;
  String connectionListFamilyRelationship;
  APIRegularConnectionListFamilyExtended({required this.connectionListFamilyUser, required this.connectionListFamilyRelationship});

  factory APIRegularConnectionListFamilyExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularConnectionListFamilyExtended(
      connectionListFamilyUser: APIRegularConnectionListFamilyExtendedDetails.fromJson(parsedJson['user']),
      connectionListFamilyRelationship: parsedJson['relationship'] ?? '',
    );
  }
}

class APIRegularConnectionListFamilyExtendedDetails{
  int connectionListFamilyDetailsId;
  String connectionListFamilyDetailsFirstName;
  String connectionListFamilyDetailsLastName;
  String connectionListFamilyDetailsImage;
  int connectionListFamilyAccountType;
  APIRegularConnectionListFamilyExtendedDetails({required this.connectionListFamilyDetailsId, required this.connectionListFamilyDetailsFirstName, required this.connectionListFamilyDetailsLastName, required this.connectionListFamilyDetailsImage, required this.connectionListFamilyAccountType});

  factory APIRegularConnectionListFamilyExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularConnectionListFamilyExtendedDetails(
      connectionListFamilyDetailsId: parsedJson['id'],
      connectionListFamilyDetailsFirstName: parsedJson['first_name'] ?? '',
      connectionListFamilyDetailsLastName: parsedJson['last_name'] ?? '',
      connectionListFamilyDetailsImage: parsedJson['image'] ?? '',
      connectionListFamilyAccountType: parsedJson['account_type'],
    );
  }
}