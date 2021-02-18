import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularConnectionListFamilyMain> apiRegularConnectionListFamily({int memorialId, int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/pages/memorials/$memorialId/family/index?page=$page',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The status code of connection list family is ${response.statusCode}');
  print('The status body of connection list family is ${response.body}');
  
  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularConnectionListFamilyMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the lists.');
  }
}

class APIRegularConnectionListFamilyMain{
  int almItemsRemaining;
  List<APIRegularConnectionListFamilyExtended> almFamilyList;

  APIRegularConnectionListFamilyMain({this.almItemsRemaining, this.almFamilyList});

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

  APIRegularConnectionListFamilyExtended({this.connectionListFamilyUser, this.connectionListFamilyRelationship});

  factory APIRegularConnectionListFamilyExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularConnectionListFamilyExtended(
      connectionListFamilyUser: APIRegularConnectionListFamilyExtendedDetails.fromJson(parsedJson['user']),
      connectionListFamilyRelationship: parsedJson['relationship'],
    );
  }
}

class APIRegularConnectionListFamilyExtendedDetails{

  int connectionListFamilyDetailsId;
  String connectionListFamilyDetailsFirstName;
  String connectionListFamilyDetailsLastName;
  dynamic connectionListFamilyDetailsImage;
  int connectionListFamilyAccountType;

  APIRegularConnectionListFamilyExtendedDetails({this.connectionListFamilyDetailsId, this.connectionListFamilyDetailsFirstName, this.connectionListFamilyDetailsLastName, this.connectionListFamilyDetailsImage, this.connectionListFamilyAccountType});

  factory APIRegularConnectionListFamilyExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularConnectionListFamilyExtendedDetails(
      connectionListFamilyDetailsId: parsedJson['id'],
      connectionListFamilyDetailsFirstName: parsedJson['first_name'],
      connectionListFamilyDetailsLastName: parsedJson['last_name'],
      connectionListFamilyDetailsImage: parsedJson['image'],
      connectionListFamilyAccountType: parsedJson['account_type'],
    );
  }
}
