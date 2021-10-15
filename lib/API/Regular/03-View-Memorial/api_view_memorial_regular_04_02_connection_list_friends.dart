import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularConnectionListFriendsMain> apiRegularConnectionListFriends({required int memorialId, required int page}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  bool userSessionRegular = sharedPrefs.getBool('regular-user-session') ?? false;
  bool userSessionBLM = sharedPrefs.getBool('blm-user-session') ?? false;
  String? getAccessToken;
  String? getUID;
  String? getClient;

  if(userSessionRegular == true){
    getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
    getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
    getClient = sharedPrefs.getString('regular-client') ?? 'empty';
  }else if(userSessionBLM == true){
    getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
    getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
    getClient = sharedPrefs.getString('blm-client') ?? 'empty';
  }

  Dio dioRequest = Dio();

  var response = await dioRequest.get('https://facesbyplaces.com/api/v1/pages/memorials/$memorialId/friends/index?page=$page',
    options: Options(
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      },
      validateStatus: (status){
        return status! < 600;
      },
      followRedirects: false,
    ),  
  );

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
      connectionListFriendsRelationship: parsedJson['relationship'] ?? '',
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
      connectionListFriendsDetailsFirstName: parsedJson['first_name'] ?? '',
      connectionListFriendsDetailsLastName: parsedJson['last_name'] ?? '',
      connectionListFriendsDetailsImage: parsedJson['image'] ?? '',
      connectionListFriendsAccountType: parsedJson['account_type'],
    );
  }
}