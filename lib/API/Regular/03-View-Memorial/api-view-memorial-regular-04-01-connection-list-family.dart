import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularConnectionListFamilyMain> apiRegularConnectionListFamily({required int memorialId, required int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/pages/memorials/$memorialId/family/index?page=$page',
    options: Options(
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  print('The status code of feed is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIRegularConnectionListFamilyMain.fromJson(newData);
  }else{
    throw Exception('Failed to show the connection list family.');
  }

  // final http.Response response = await http.get(
  //   Uri.http('http://fbp.dev1.koda.ws/api/v1/pages/memorials/$memorialId/family/index?page=$page', ''),
  //   headers: <String, String>{
  //     'Content-Type': 'application/json',
  //     'access-token': getAccessToken,
  //     'uid': getUID,
  //     'client': getClient,
  //   }
  // );
  
  // if(response.statusCode == 200){
  //   var newValue = json.decode(response.body);
  //   return APIRegularConnectionListFamilyMain.fromJson(newValue);
  // }else{
  //   throw Exception('Failed to get the lists.');
  // }
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
      connectionListFamilyRelationship: parsedJson['relationship'] != null ? parsedJson['relationship'] : '',
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
      connectionListFamilyDetailsFirstName: parsedJson['first_name'] != null ? parsedJson['first_name'] : '',
      connectionListFamilyDetailsLastName: parsedJson['last_name'] != null ? parsedJson['last_name'] : '',
      connectionListFamilyDetailsImage: parsedJson['image'] != null ? parsedJson['image'] : '',
      connectionListFamilyAccountType: parsedJson['account_type'],
    );
  }
}
