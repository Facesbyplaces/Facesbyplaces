// ignore_for_file: file_names
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIBLMConnectionListFollowersMain> apiBLMConnectionListFollowers({required int memorialId, required int page}) async{
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

  var response = await dioRequest.get('http://facesbyplaces.com/api/v1/pages/blm/$memorialId/followers/index?page=$page',
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

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIBLMConnectionListFollowersMain.fromJson(newData);
  }else{
    throw Exception('Failed to get the lists.');
  }
}

class APIBLMConnectionListFollowersMain{
  int blmItemsRemaining;
  List<APIBLMConnectionListFollowersExtendedDetails> blmFollowersList;
  APIBLMConnectionListFollowersMain({required this.blmItemsRemaining, required this.blmFollowersList});

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
  String connectionListFollowersImage;
  int connectionListFollowersAccountType;
  APIBLMConnectionListFollowersExtendedDetails({required this.connectionListFollowersId, required this.connectionListFollowersFirstName, required this.connectionListFollowersLastName, required this.connectionListFollowersImage, required this.connectionListFollowersAccountType});

  factory APIBLMConnectionListFollowersExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMConnectionListFollowersExtendedDetails(
      connectionListFollowersId: parsedJson['id'],
      connectionListFollowersFirstName: parsedJson['first_name'] ?? '',
      connectionListFollowersLastName: parsedJson['last_name'] ?? '',
      connectionListFollowersImage: parsedJson['image'] ?? '',
      connectionListFollowersAccountType: parsedJson['account_type'],
    );
  }
}