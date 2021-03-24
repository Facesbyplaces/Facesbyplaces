import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularConnectionListFriendsMain> apiRegularConnectionListFriends({required int memorialId, required int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/pages/memorials/$memorialId/friends/index?page=$page',
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
    return APIRegularConnectionListFriendsMain.fromJson(newData);
  }else{
    throw Exception('Failed to show the connection list friends.');
  }
}

class APIRegularConnectionListFriendsMain{
  int almItemsRemaining;
  List<APIRegularConnectionListFriendsExtended> almFriendsList;

  APIRegularConnectionListFriendsMain({required this.almItemsRemaining, required this.almFriendsList});

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

  APIRegularConnectionListFriendsExtended({required this.connectionListFriendsUser, required this.connectionListFriendsRelationship});

  factory APIRegularConnectionListFriendsExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularConnectionListFriendsExtended(
      connectionListFriendsUser: APIRegularConnectionListFriendsExtendedDetails.fromJson(parsedJson['user']),
      connectionListFriendsRelationship: parsedJson['relationship'] != null ? parsedJson['relationship'] : '',
    );
  }
}

class APIRegularConnectionListFriendsExtendedDetails{

  int connectionListFriendsDetailsId;
  String connectionListFriendsDetailsFirstName;
  String connectionListFriendsDetailsLastName;
  String connectionListFriendsDetailsImage;
  int connectionListFriendsAccountType;

  APIRegularConnectionListFriendsExtendedDetails({required this.connectionListFriendsDetailsId, required this.connectionListFriendsDetailsFirstName, required this.connectionListFriendsDetailsLastName, required this.connectionListFriendsDetailsImage, required this.connectionListFriendsAccountType});

  factory APIRegularConnectionListFriendsExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularConnectionListFriendsExtendedDetails(
      connectionListFriendsDetailsId: parsedJson['id'],
      connectionListFriendsDetailsFirstName: parsedJson['first_name'] != null ? parsedJson['first_name'] : '',
      connectionListFriendsDetailsLastName: parsedJson['last_name'] != null ? parsedJson['last_name'] : '',
      connectionListFriendsDetailsImage: parsedJson['image'] != null ? parsedJson['image'] : '',
      connectionListFriendsAccountType: parsedJson['account_type'],
    );
  }
}