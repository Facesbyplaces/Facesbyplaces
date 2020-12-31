import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularConnectionListFollowersMain> apiRegularConnectionListFollowers(int memorialId, int page) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/pages/memorials/$memorialId/followers/index?page=$page',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    },
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularConnectionListFollowersMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the lists.');
  }
}

class APIRegularConnectionListFollowersMain{
  int itemsRemaining;
  List<APIRegularConnectionListFollowersExtended> followersList;

  APIRegularConnectionListFollowersMain({this.itemsRemaining, this.followersList});

  factory APIRegularConnectionListFollowersMain.fromJson(Map<String, dynamic> parsedJson){

    var newList1 = parsedJson['followers'] as List;
    List<APIRegularConnectionListFollowersExtended> familyList = newList1.map((i) => APIRegularConnectionListFollowersExtended.fromJson(i)).toList();

    return APIRegularConnectionListFollowersMain(
      itemsRemaining: parsedJson['itemsremaining'],
      followersList: familyList,
    );
  }
}


class APIRegularConnectionListFollowersExtended{
  APIRegularConnectionListFollowersExtendedDetails user;
  String relationship;

  APIRegularConnectionListFollowersExtended({this.user, this.relationship});

  factory APIRegularConnectionListFollowersExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularConnectionListFollowersExtended(
      user: APIRegularConnectionListFollowersExtendedDetails.fromJson(parsedJson['user']),
      relationship: parsedJson['relationship'],
    );
  }
}

class APIRegularConnectionListFollowersExtendedDetails{

  int id;
  String firstName;
  String lastName;
  dynamic image;

  APIRegularConnectionListFollowersExtendedDetails({this.id, this.firstName, this.lastName, this.image});

  factory APIRegularConnectionListFollowersExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularConnectionListFollowersExtendedDetails(
      id: parsedJson['id'],
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      image: parsedJson['image'],
    );
  }
}
