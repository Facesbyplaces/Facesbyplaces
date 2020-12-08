import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMConnectionListFollowersMain> apiBLMConnectionListFollowers(int memorialId, int page) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  print('The memorial id is $memorialId');
  print('The page number is $page');

  final http.Response response = await http.get(
    'http://fbp.dev1.koda.ws/api/v1/pages/blm/$memorialId/followers/index?page=$page',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The status of page friends is ${response.statusCode}');
  print('The status of page friends is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMConnectionListFollowersMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the lists.');
  }
}



class APIBLMConnectionListFollowersMain{
  int itemsRemaining;
  List<APIBLMConnectionListFollowersExtended> followersList;

  APIBLMConnectionListFollowersMain({this.itemsRemaining, this.followersList});

  factory APIBLMConnectionListFollowersMain.fromJson(Map<String, dynamic> parsedJson){

    var newList1 = parsedJson['followers'] as List;
    List<APIBLMConnectionListFollowersExtended> familyList = newList1.map((i) => APIBLMConnectionListFollowersExtended.fromJson(i)).toList();

    return APIBLMConnectionListFollowersMain(
      itemsRemaining: parsedJson['itemsremaining'],
      followersList: familyList,
    );
  }
}


class APIBLMConnectionListFollowersExtended{
  APIBLMConnectionListFollowersExtendedDetails user;
  String relationship;

  APIBLMConnectionListFollowersExtended({this.user, this.relationship});

  factory APIBLMConnectionListFollowersExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMConnectionListFollowersExtended(
      user: APIBLMConnectionListFollowersExtendedDetails.fromJson(parsedJson['user']),
      relationship: parsedJson['relationship'],
    );
  }
}

class APIBLMConnectionListFollowersExtendedDetails{

  int id;
  String firstName;
  String lastName;
  dynamic image;

  APIBLMConnectionListFollowersExtendedDetails({this.id, this.firstName, this.lastName, this.image});

  factory APIBLMConnectionListFollowersExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMConnectionListFollowersExtendedDetails(
      id: parsedJson['id'],
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      image: parsedJson['image'],
    );
  }
}
