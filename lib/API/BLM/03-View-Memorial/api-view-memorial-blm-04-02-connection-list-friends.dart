import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

Future<APIBLMConnectionListFriendsMain> apiBLMConnectionListFriends({required int memorialId, required int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  // final http.Response response = await http.get(
  //   Uri.http('http://fbp.dev1.koda.ws/api/v1/pages/blm/$memorialId/friends/index?page=$page', ''),
  //   headers: <String, String>{
  //     'Content-Type': 'application/json',
  //     'access-token': getAccessToken,
  //     'uid': getUID,
  //     'client': getClient,
  //   }
  // );
  
  // if(response.statusCode == 200){
  //   var newValue = json.decode(response.body);
  //   return APIBLMConnectionListFriendsMain.fromJson(newValue);
  // }else{
  //   throw Exception('Failed to get the lists.');
  // }

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/pages/blm/$memorialId/friends/index?page=$page',
    options: Options(
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  print('The status code of connection list friends is ${response.statusCode}');

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
      connectionListFriendsRelationship: parsedJson['relationship'],
    );
  }
}

class APIBLMConnectionListFriendsExtendedDetails{

  int connectionListFriendsDetailsId;
  String connectionListFriendsDetailsFirstName;
  String connectionListFriendsDetailsLastName;
  dynamic connectionListFriendsDetailsImage;
  int connectionListFriendsAccountType;

  APIBLMConnectionListFriendsExtendedDetails({required this.connectionListFriendsDetailsId, required this.connectionListFriendsDetailsFirstName, required this.connectionListFriendsDetailsLastName, required this.connectionListFriendsDetailsImage, required this.connectionListFriendsAccountType});

  factory APIBLMConnectionListFriendsExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMConnectionListFriendsExtendedDetails(
      connectionListFriendsDetailsId: parsedJson['id'],
      connectionListFriendsDetailsFirstName: parsedJson['first_name'],
      connectionListFriendsDetailsLastName: parsedJson['last_name'],
      connectionListFriendsDetailsImage: parsedJson['image'],
      connectionListFriendsAccountType: parsedJson['account_type'],
    );
  }
}
