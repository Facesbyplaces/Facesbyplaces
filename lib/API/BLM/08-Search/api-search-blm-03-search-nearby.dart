import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIBLMSearchNearbyMain> apiBLMSearchNearby({required int page, required double latitude, required double longitude}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  // var response = await dioRequest.get('http://45.33.66.25:3001/api/v1/search/nearby?longitude=$longitude&latitude=$latitude&page=$page',
  var response = await dioRequest.get('http://facesbyplaces.com/api/v1/search/nearby?longitude=$longitude&latitude=$latitude&page=$page',
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

  print('The status code of blm search nearby is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIBLMSearchNearbyMain.fromJson(newData);
  }else{
    throw Exception('Failed to get the nearby');
  }
}

class APIBLMSearchNearbyMain{
  int blmItemsRemaining;
  int memorialItemsRemaining;
  List<APIBLMSearchNearbyExtended> blmList;
  List<APIBLMSearchNearbyExtended> memorialList;
  APIBLMSearchNearbyMain({required this.blmItemsRemaining, required this.memorialItemsRemaining, required this.blmList, required this.memorialList});

  factory APIBLMSearchNearbyMain.fromJson(Map<String, dynamic> parsedJson){
    var newList1 = parsedJson['blm'] as List;
    var newList2 = parsedJson['memorial'] as List;

    List<APIBLMSearchNearbyExtended> blmList = newList1.map((i) => APIBLMSearchNearbyExtended.fromJson(i)).toList();
    List<APIBLMSearchNearbyExtended> memorialList = newList2.map((e) => APIBLMSearchNearbyExtended.fromJson(e)).toList();

    return APIBLMSearchNearbyMain(
      blmItemsRemaining: parsedJson['blmItemsRemaining'],
      memorialItemsRemaining: parsedJson['memorialItemsRemaining'],
      blmList: blmList,
      memorialList: memorialList,
    );
  }
}

class APIBLMSearchNearbyExtended{
  int searchNearbyId;
  String searchNearbyName;
  APIBLMSearchNearbyExtendedPageDetails searchNearbyDetails;
  dynamic searchNearbyProfileImage;
  String searchNearbyRelationship;
  bool searchNearbyManage;
  bool searchNearbyFamOrFriends;
  bool searchNearbyFollower;
  String searchNearbyPageType;
  APIBLMSearchNearbyExtended({required this.searchNearbyId, required this.searchNearbyName, required this.searchNearbyDetails, required this.searchNearbyProfileImage, required this.searchNearbyRelationship, required this.searchNearbyManage, required this.searchNearbyFamOrFriends, required this.searchNearbyFollower, required this.searchNearbyPageType});

  factory APIBLMSearchNearbyExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMSearchNearbyExtended(
      searchNearbyId: parsedJson['id'],
      searchNearbyName: parsedJson['name'] != null ? parsedJson['name'] : '',
      searchNearbyDetails: APIBLMSearchNearbyExtendedPageDetails.fromJson(parsedJson['details']),
      searchNearbyProfileImage: parsedJson['profileImage'],
      searchNearbyRelationship: parsedJson['relationship'] != null ? parsedJson['relationship'] : '',
      searchNearbyManage: parsedJson['manage'],
      searchNearbyFamOrFriends: parsedJson['famOrFriends'],
      searchNearbyFollower: parsedJson['follower'],
      searchNearbyPageType: parsedJson['page_type'] != null ? parsedJson['page_type'] : '',
    );
  }
}

class APIBLMSearchNearbyExtendedPageDetails{
  String searchNearbyPageDetailsDescription;
  APIBLMSearchNearbyExtendedPageDetails({required this.searchNearbyPageDetailsDescription});

  factory APIBLMSearchNearbyExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMSearchNearbyExtendedPageDetails(
      searchNearbyPageDetailsDescription: parsedJson['description'] != null ? parsedJson['description'] : '',
    );
  }
}