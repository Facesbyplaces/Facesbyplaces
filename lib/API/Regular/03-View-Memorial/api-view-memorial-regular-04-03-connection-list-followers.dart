// ignore_for_file: file_names
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularConnectionListFollowersMain> apiRegularConnectionListFollowers({required int memorialId, required int page}) async{
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

  var response = await dioRequest.get('http://facesbyplaces.com/api/v1/pages/memorials/$memorialId/followers/index?page=$page',
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

  print('The status code of regular connection list followers is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIRegularConnectionListFollowersMain.fromJson(newData);
  }else{
    throw Exception('Failed to show the connection list followers.');
  }
}

class APIRegularConnectionListFollowersMain{
  int almItemsRemaining;
  List<APIRegularConnectionListFollowersExtendedDetails> almFollowersList;
  APIRegularConnectionListFollowersMain({required this.almItemsRemaining, required this.almFollowersList});

  factory APIRegularConnectionListFollowersMain.fromJson(Map<String, dynamic> parsedJson){
    var newList1 = parsedJson['followers'] as List;
    List<APIRegularConnectionListFollowersExtendedDetails> familyList = newList1.map((i) => APIRegularConnectionListFollowersExtendedDetails.fromJson(i)).toList();

    return APIRegularConnectionListFollowersMain(
      almItemsRemaining: parsedJson['itemsremaining'],
      almFollowersList: familyList,
    );
  }
}

class APIRegularConnectionListFollowersExtendedDetails{
  int connectionListFollowersDetailsId;
  String connectionListFollowersDetailsFirstName;
  String connectionListFollowersDetailsLastName;
  String connectionListFollowersDetailsImage;
  int connectionListFollowersAccountType;
  APIRegularConnectionListFollowersExtendedDetails({required this.connectionListFollowersDetailsId, required this.connectionListFollowersDetailsFirstName, required this.connectionListFollowersDetailsLastName, required this.connectionListFollowersDetailsImage, required this.connectionListFollowersAccountType});

  factory APIRegularConnectionListFollowersExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularConnectionListFollowersExtendedDetails(
      connectionListFollowersDetailsId: parsedJson['id'],
      connectionListFollowersDetailsFirstName: parsedJson['first_name'] != null ? parsedJson['first_name'] : '',
      connectionListFollowersDetailsLastName: parsedJson['last_name'] != null ? parsedJson['last_name'] : '',
      connectionListFollowersDetailsImage: parsedJson['image'] != null ? parsedJson['image'] : '',
      connectionListFollowersAccountType: parsedJson['account_type'],
    );
  }
}