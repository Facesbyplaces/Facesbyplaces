import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIBLMConnectionListFriendsMain> apiBLMConnectionListFriends({required int memorialId, required int page}) async{
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

  // var response = await dioRequest.get('http://45.33.66.25:3001/api/v1/pages/blm/$memorialId/friends/index?page=$page',
  var response = await dioRequest.get('http://facesbyplaces.com/api/v1/pages/blm/$memorialId/friends/index?page=$page',
    options: Options(
      followRedirects: false,
      validateStatus: (status){
        return status! < 600;
      },
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  print('The status code of blm connection list friends is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIBLMConnectionListFriendsMain.fromJson(newData);
  }else{
    throw Exception('Failed to get the lists.');
  }
}

class APIBLMConnectionListFriendsMain{
  int blmItemsRemaining;
  List<APIBLMConnectionListFriendsExtended> blmFriendsList;
  APIBLMConnectionListFriendsMain({required this.blmItemsRemaining, required this.blmFriendsList});

  factory APIBLMConnectionListFriendsMain.fromJson(Map<String, dynamic> parsedJson){
    var newList1 = parsedJson['friends'] as List;
    List<APIBLMConnectionListFriendsExtended> familyList = newList1.map((i) => APIBLMConnectionListFriendsExtended.fromJson(i)).toList();

    return APIBLMConnectionListFriendsMain(
      blmItemsRemaining: parsedJson['itemsremaining'],
      blmFriendsList: familyList,
    );
  }
}

class APIBLMConnectionListFriendsExtended{
  APIBLMConnectionListFriendsExtendedDetails connectionListFriendsUser;
  String connectionListFriendsRelationship;
  APIBLMConnectionListFriendsExtended({required this.connectionListFriendsUser, required this.connectionListFriendsRelationship});

  factory APIBLMConnectionListFriendsExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMConnectionListFriendsExtended(
      connectionListFriendsUser: APIBLMConnectionListFriendsExtendedDetails.fromJson(parsedJson['user']),
      connectionListFriendsRelationship: parsedJson['relationship'] != null ? parsedJson['relationship'] : '',
    );
  }
}

class APIBLMConnectionListFriendsExtendedDetails{
  int connectionListFriendsDetailsId;
  String connectionListFriendsDetailsFirstName;
  String connectionListFriendsDetailsLastName;
  String connectionListFriendsDetailsImage;
  int connectionListFriendsAccountType;
  APIBLMConnectionListFriendsExtendedDetails({required this.connectionListFriendsDetailsId, required this.connectionListFriendsDetailsFirstName, required this.connectionListFriendsDetailsLastName, required this.connectionListFriendsDetailsImage, required this.connectionListFriendsAccountType});

  factory APIBLMConnectionListFriendsExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMConnectionListFriendsExtendedDetails(
      connectionListFriendsDetailsId: parsedJson['id'],
      connectionListFriendsDetailsFirstName: parsedJson['first_name'] != null ? parsedJson['first_name'] : '',
      connectionListFriendsDetailsLastName: parsedJson['last_name'] != null ? parsedJson['last_name'] : '',
      connectionListFriendsDetailsImage: parsedJson['image'] != null ? parsedJson['image'] : '',
      connectionListFriendsAccountType: parsedJson['account_type'],
    );
  }
}