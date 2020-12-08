import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMConnectionListFriendsMain> apiBLMConnectionListFriends(int memorialId, int page) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  print('The memorial id is $memorialId');
  print('The page number is $page');

  final http.Response response = await http.get(
    // 'http://fbp.dev1.koda.ws/api/v1/pages/blm/$memorialId/family/index?page=$page',
    'http://fbp.dev1.koda.ws/api/v1/pages/blm/$memorialId/friends/index?page=$page',
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
    return APIBLMConnectionListFriendsMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the lists.');
  }
}



class APIBLMConnectionListFriendsMain{
  int itemsRemaining;
  List<APIBLMConnectionListFriendsExtended> friendsList;

  APIBLMConnectionListFriendsMain({this.itemsRemaining, this.friendsList});

  factory APIBLMConnectionListFriendsMain.fromJson(Map<String, dynamic> parsedJson){

    var newList1 = parsedJson['friends'] as List;
    List<APIBLMConnectionListFriendsExtended> familyList = newList1.map((i) => APIBLMConnectionListFriendsExtended.fromJson(i)).toList();

    return APIBLMConnectionListFriendsMain(
      itemsRemaining: parsedJson['itemsremaining'],
      friendsList: familyList,
    );
  }
}


class APIBLMConnectionListFriendsExtended{
  APIBLMConnectionListFriendsExtendedDetails user;
  String relationship;

  APIBLMConnectionListFriendsExtended({this.user, this.relationship});

  factory APIBLMConnectionListFriendsExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMConnectionListFriendsExtended(
      user: APIBLMConnectionListFriendsExtendedDetails.fromJson(parsedJson['user']),
      relationship: parsedJson['relationship'],
    );
  }
}

class APIBLMConnectionListFriendsExtendedDetails{

  int id;
  String firstName;
  String lastName;
  dynamic image;

  APIBLMConnectionListFriendsExtendedDetails({this.id, this.firstName, this.lastName, this.image});

  factory APIBLMConnectionListFriendsExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMConnectionListFriendsExtendedDetails(
      id: parsedJson['id'],
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      image: parsedJson['image'],
    );
  }
}
