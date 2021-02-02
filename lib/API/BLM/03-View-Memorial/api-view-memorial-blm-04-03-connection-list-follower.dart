import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMConnectionListFollowersMain> apiBLMConnectionListFollowers({int memorialId, int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/pages/blm/$memorialId/followers/index?page=$page',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    },
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMConnectionListFollowersMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the lists.');
  }
}

class APIBLMConnectionListFollowersMain{
  int blmItemsRemaining;
  List<APIBLMConnectionListFollowersExtendedDetails> blmFollowersList;

  APIBLMConnectionListFollowersMain({this.blmItemsRemaining, this.blmFollowersList});

  factory APIBLMConnectionListFollowersMain.fromJson(Map<String, dynamic> parsedJson){

    var newList1 = parsedJson['followers'] as List;
    List<APIBLMConnectionListFollowersExtendedDetails> familyList = newList1.map((i) => APIBLMConnectionListFollowersExtendedDetails.fromJson(i)).toList();

    return APIBLMConnectionListFollowersMain(
      blmItemsRemaining: parsedJson['itemsremaining'],
      blmFollowersList: familyList,
    );
  }
}

class APIBLMConnectionListFollowersExtendedDetails{

  int connectionListFollowersId;
  String connectionListFollowersFirstName;
  String connectionListFollowersLastName;
  dynamic connectionListFollowersImage;

  APIBLMConnectionListFollowersExtendedDetails({this.connectionListFollowersId, this.connectionListFollowersFirstName, this.connectionListFollowersLastName, this.connectionListFollowersImage});

  factory APIBLMConnectionListFollowersExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMConnectionListFollowersExtendedDetails(
      connectionListFollowersId: parsedJson['id'],
      connectionListFollowersFirstName: parsedJson['first_name'],
      connectionListFollowersLastName: parsedJson['last_name'],
      connectionListFollowersImage: parsedJson['image'],
    );
  }
}
