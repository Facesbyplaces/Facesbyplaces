// ignore_for_file: file_names
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularSearchNearbyMain> apiRegularSearchNearby({required int page, required double latitude, required double longitude}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

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

  print('The status code of regular search nearby is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIRegularSearchNearbyMain.fromJson(newData);
  }else{
    throw Exception('Failed to get the nearby list');
  }
}

class APIRegularSearchNearbyMain{
  int blmItemsRemaining;
  int memorialItemsRemaining;
  List<APIRegularSearchNearbyExtended> blmList;
  List<APIRegularSearchNearbyExtended> memorialList;
  APIRegularSearchNearbyMain({required this.blmItemsRemaining, required this.memorialItemsRemaining, required this.blmList, required this.memorialList});

  factory APIRegularSearchNearbyMain.fromJson(Map<String, dynamic> parsedJson){
    var newList1 = parsedJson['blm'] as List;
    var newList2 = parsedJson['memorial'] as List;

    List<APIRegularSearchNearbyExtended> blmList = newList1.map((i) => APIRegularSearchNearbyExtended.fromJson(i)).toList();
    List<APIRegularSearchNearbyExtended> memorialList = newList2.map((e) => APIRegularSearchNearbyExtended.fromJson(e)).toList();

    return APIRegularSearchNearbyMain(
      blmItemsRemaining: parsedJson['blmItemsRemaining'],
      memorialItemsRemaining: parsedJson['memorialItemsRemaining'],
      blmList: blmList,
      memorialList: memorialList,
    );
  }
}

class APIRegularSearchNearbyExtended{
  int searchNearbyId;
  String searchNearbyName;
  APIRegularSearchNearbyExtendedPageDetails searchNearbyDetails;
  String searchNearbyProfileImage;
  String searchNearbyRelationship;
  bool searchNearbyManage;
  bool searchNearbyFamOrFriends;
  bool searchNearbyFollower;
  String searchNearbyPageType;
  APIRegularSearchNearbyExtended({required this.searchNearbyId, required this.searchNearbyName, required this.searchNearbyDetails, required this.searchNearbyProfileImage, required this.searchNearbyRelationship, required this.searchNearbyManage, required this.searchNearbyFamOrFriends, required this.searchNearbyFollower, required this.searchNearbyPageType,});

  factory APIRegularSearchNearbyExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularSearchNearbyExtended(
      searchNearbyId: parsedJson['id'],
      searchNearbyName: parsedJson['name'],
      searchNearbyDetails: APIRegularSearchNearbyExtendedPageDetails.fromJson(parsedJson['details']),
      searchNearbyProfileImage: parsedJson['profileImage'] != null ? parsedJson['profileImage'] : '',
      searchNearbyRelationship: parsedJson['relationship'] != null ? parsedJson['relationship'] : '',
      searchNearbyManage: parsedJson['manage'],
      searchNearbyFamOrFriends: parsedJson['famOrFriends'],
      searchNearbyFollower: parsedJson['follower'],
      searchNearbyPageType: parsedJson['page_type'] != null ? parsedJson['page_type'] : '',
    );
  }
}

class APIRegularSearchNearbyExtendedPageDetails{
  String searchNearbyPageDetailsDescription;
  APIRegularSearchNearbyExtendedPageDetails({required this.searchNearbyPageDetailsDescription,});

  factory APIRegularSearchNearbyExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularSearchNearbyExtendedPageDetails(
      searchNearbyPageDetailsDescription: parsedJson['description'] != null ? parsedJson['description'] : '',
    );
  }
}