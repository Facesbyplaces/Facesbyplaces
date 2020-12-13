import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularConnectionListFriendsMain> apiRegularConnectionListFriends(int memorialId, int page) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  print('The memorial id is $memorialId');
  print('The page number is $page');

  final http.Response response = await http.get(
    'http://fbp.dev1.koda.ws/api/v1/pages/memorials/$memorialId/friends/index?page=$page',
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
    return APIRegularConnectionListFriendsMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the lists.');
  }
}



class APIRegularConnectionListFriendsMain{
  int itemsRemaining;
  List<APIRegularConnectionListFriendsExtended> friendsList;

  APIRegularConnectionListFriendsMain({this.itemsRemaining, this.friendsList});

  factory APIRegularConnectionListFriendsMain.fromJson(Map<String, dynamic> parsedJson){

    var newList1 = parsedJson['friends'] as List;
    List<APIRegularConnectionListFriendsExtended> familyList = newList1.map((i) => APIRegularConnectionListFriendsExtended.fromJson(i)).toList();

    return APIRegularConnectionListFriendsMain(
      itemsRemaining: parsedJson['itemsremaining'],
      friendsList: familyList,
    );
  }
}


class APIRegularConnectionListFriendsExtended{
  APIRegularConnectionListFriendsExtendedDetails user;
  String relationship;

  APIRegularConnectionListFriendsExtended({this.user, this.relationship});

  factory APIRegularConnectionListFriendsExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularConnectionListFriendsExtended(
      user: APIRegularConnectionListFriendsExtendedDetails.fromJson(parsedJson['user']),
      relationship: parsedJson['relationship'],
    );
  }
}

class APIRegularConnectionListFriendsExtendedDetails{

  int id;
  String firstName;
  String lastName;
  dynamic image;

  APIRegularConnectionListFriendsExtendedDetails({this.id, this.firstName, this.lastName, this.image});

  factory APIRegularConnectionListFriendsExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularConnectionListFriendsExtendedDetails(
      id: parsedJson['id'],
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      image: parsedJson['image'],
    );
  }
}
