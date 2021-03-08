import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMConnectionListFamilyMain> apiBLMConnectionListFamily({required int memorialId, required int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get(
    Uri.http('http://fbp.dev1.koda.ws/api/v1/pages/blm/$memorialId/family/index?page=$page', ''),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMConnectionListFamilyMain.fromJson(newValue);
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
      connectionListFamilyRelationship: parsedJson['relationship'],
    );
  }
}

class APIBLMConnectionListFamilyExtendedDetails{

  int connectionListFamilyDetailsId;
  String connectionListFamilyDetailsFirstName;
  String connectionListFamilyDetailsLastName;
  dynamic connectionListFamilyDetailsImage;
  int connectionListFamilyAccountType;

  APIBLMConnectionListFamilyExtendedDetails({required this.connectionListFamilyDetailsId, required this.connectionListFamilyDetailsFirstName, required this.connectionListFamilyDetailsLastName, required this.connectionListFamilyDetailsImage, required this.connectionListFamilyAccountType});

  factory APIBLMConnectionListFamilyExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMConnectionListFamilyExtendedDetails(
      connectionListFamilyDetailsId: parsedJson['id'],
      connectionListFamilyDetailsFirstName: parsedJson['first_name'],
      connectionListFamilyDetailsLastName: parsedJson['last_name'],
      connectionListFamilyDetailsImage: parsedJson['image'],
      connectionListFamilyAccountType: parsedJson['account_type'],
    );
  }
}
