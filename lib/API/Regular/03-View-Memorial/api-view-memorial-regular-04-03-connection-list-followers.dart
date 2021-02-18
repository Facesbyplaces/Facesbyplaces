import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularConnectionListFollowersMain> apiRegularConnectionListFollowers({int memorialId, int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  print('The page id is $memorialId');

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/pages/memorials/$memorialId/followers/index?page=$page',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    },
  );

  print('The status code of connection list followers is ${response.statusCode}');
  print('The status body of connection list followers is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularConnectionListFollowersMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the lists.');
  }
}

class APIRegularConnectionListFollowersMain{
  int almItemsRemaining;
  List<APIRegularConnectionListFollowersExtendedDetails> almFollowersList;

  APIRegularConnectionListFollowersMain({this.almItemsRemaining, this.almFollowersList});

  factory APIRegularConnectionListFollowersMain.fromJson(Map<String, dynamic> parsedJson){

    var newList1 = parsedJson['followers'] as List;
    List<APIRegularConnectionListFollowersExtendedDetails> familyList = newList1.map((i) => APIRegularConnectionListFollowersExtendedDetails.fromJson(i)).toList();

    return APIRegularConnectionListFollowersMain(
      almItemsRemaining: parsedJson['itemsremaining'],
      almFollowersList: familyList,
    );
  }
}

class APIRegularConnectionListFollowersExtendedDetails{

  int connectionListFollowersDetailsId;
  String connectionListFollowersDetailsFirstName;
  String connectionListFollowersDetailsLastName;
  dynamic connectionListFollowersDetailsImage;
  int connectionListFollowersAccountType;

  APIRegularConnectionListFollowersExtendedDetails({this.connectionListFollowersDetailsId, this.connectionListFollowersDetailsFirstName, this.connectionListFollowersDetailsLastName, this.connectionListFollowersDetailsImage, this.connectionListFollowersAccountType});

  factory APIRegularConnectionListFollowersExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularConnectionListFollowersExtendedDetails(
      connectionListFollowersDetailsId: parsedJson['id'],
      connectionListFollowersDetailsFirstName: parsedJson['first_name'],
      connectionListFollowersDetailsLastName: parsedJson['last_name'],
      connectionListFollowersDetailsImage: parsedJson['image'],
      connectionListFollowersAccountType: parsedJson['account_type'],
    );
  }
}