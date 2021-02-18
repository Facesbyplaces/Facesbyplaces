import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularConnectionListFriendsMain> apiRegularConnectionListFriends({int memorialId, int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/pages/memorials/$memorialId/friends/index?page=$page',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The status code of connection list friends is ${response.statusCode}');
  print('The status body of connection list friends is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularConnectionListFriendsMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the lists.');
  }
}

class APIRegularConnectionListFriendsMain{
  int almItemsRemaining;
  List<APIRegularConnectionListFriendsExtended> almFriendsList;

  APIRegularConnectionListFriendsMain({this.almItemsRemaining, this.almFriendsList});

  factory APIRegularConnectionListFriendsMain.fromJson(Map<String, dynamic> parsedJson){

    var newList1 = parsedJson['friends'] as List;
    List<APIRegularConnectionListFriendsExtended> familyList = newList1.map((i) => APIRegularConnectionListFriendsExtended.fromJson(i)).toList();

    return APIRegularConnectionListFriendsMain(
      almItemsRemaining: parsedJson['itemsremaining'],
      almFriendsList: familyList,
    );
  }
}

class APIRegularConnectionListFriendsExtended{
  APIRegularConnectionListFriendsExtendedDetails connectionListFriendsUser;
  String connectionListFriendsRelationship;

  APIRegularConnectionListFriendsExtended({this.connectionListFriendsUser, this.connectionListFriendsRelationship});

  factory APIRegularConnectionListFriendsExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularConnectionListFriendsExtended(
      connectionListFriendsUser: APIRegularConnectionListFriendsExtendedDetails.fromJson(parsedJson['user']),
      connectionListFriendsRelationship: parsedJson['relationship'],
    );
  }
}

class APIRegularConnectionListFriendsExtendedDetails{

  int connectionListFriendsDetailsId;
  String connectionListFriendsDetailsFirstName;
  String connectionListFriendsDetailsLastName;
  dynamic connectionListFriendsDetailsImage;
  int connectionListFriendsAccountType;

  APIRegularConnectionListFriendsExtendedDetails({this.connectionListFriendsDetailsId, this.connectionListFriendsDetailsFirstName, this.connectionListFriendsDetailsLastName, this.connectionListFriendsDetailsImage, this.connectionListFriendsAccountType});

  factory APIRegularConnectionListFriendsExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularConnectionListFriendsExtendedDetails(
      connectionListFriendsDetailsId: parsedJson['id'],
      connectionListFriendsDetailsFirstName: parsedJson['first_name'],
      connectionListFriendsDetailsLastName: parsedJson['last_name'],
      connectionListFriendsDetailsImage: parsedJson['image'],
      connectionListFriendsAccountType: parsedJson['account_type'],
    );
  }
}
