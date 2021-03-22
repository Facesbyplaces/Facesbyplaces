import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularSearchSuggestedMain> apiRegularSearchSuggested({required int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/search/suggested/?page=$page',
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
    return APIRegularSearchSuggestedMain.fromJson(newData);
  }else{
    throw Exception('Failed to get the suggestions');
  }
}

class APIRegularSearchSuggestedMain{
  int almItemsRemaining;
  List<APIRegularSearchSuggestedExtended> almSearchSuggestedPages;

  APIRegularSearchSuggestedMain({required this.almItemsRemaining, required this.almSearchSuggestedPages});

  factory APIRegularSearchSuggestedMain.fromJson(Map<String, dynamic> parsedJson){

    var newList = parsedJson['pages'] as List;
    List<APIRegularSearchSuggestedExtended> pagesList = newList.map((i) => APIRegularSearchSuggestedExtended.fromJson(i)).toList();

    return APIRegularSearchSuggestedMain(
      almItemsRemaining: parsedJson['itemsRemaining'],
      almSearchSuggestedPages: pagesList,
    );
  }
}

class APIRegularSearchSuggestedExtended{
  int searchSuggestedId;
  APIRegularSearchSuggestedExtendedPage searchSuggestedPage;

  APIRegularSearchSuggestedExtended({required this.searchSuggestedId, required this.searchSuggestedPage});

  factory APIRegularSearchSuggestedExtended.fromJson(Map<String, dynamic> parsedJson){
    
    return APIRegularSearchSuggestedExtended(
      searchSuggestedId: parsedJson['id'],
      searchSuggestedPage: APIRegularSearchSuggestedExtendedPage.fromJson(parsedJson['page'])
    );
  }
}

class APIRegularSearchSuggestedExtendedPage{
  int searchSuggestedPageId;
  String searchSuggestedPageName;
  APIRegularSearchSuggestedExtendedPageDetails searchSuggestedPageDetails;
  String searchSuggestedPageProfileImage;
  String searchSuggestedPageRelationship;
  bool searchSuggestedPageManage;
  bool searchSuggestedPageFamOrFriends;
  bool searchSuggestedPageFollower;
  String searchSuggestedPagePageType;

  APIRegularSearchSuggestedExtendedPage({required this.searchSuggestedPageId, required this.searchSuggestedPageName, required this.searchSuggestedPageDetails, required this.searchSuggestedPageProfileImage, required this.searchSuggestedPageRelationship, required this.searchSuggestedPageManage, required this.searchSuggestedPageFamOrFriends, required this.searchSuggestedPageFollower, required this.searchSuggestedPagePageType});

  factory APIRegularSearchSuggestedExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularSearchSuggestedExtendedPage(
      searchSuggestedPageId: parsedJson['id'],
      searchSuggestedPageName: parsedJson['name'] != null ? parsedJson['name'] : '',
      searchSuggestedPageDetails: APIRegularSearchSuggestedExtendedPageDetails.fromJson(parsedJson['details']),
      searchSuggestedPageProfileImage: parsedJson['profileImage'] != null ? parsedJson['profileImage'] : '',
      searchSuggestedPageRelationship: parsedJson['relationship'] != null ? parsedJson['relationship'] : '',
      searchSuggestedPageManage: parsedJson['manage'],
      searchSuggestedPageFamOrFriends: parsedJson['famOrFriends'],
      searchSuggestedPageFollower: parsedJson['follower'],
      searchSuggestedPagePageType: parsedJson['page_type'] != null ? parsedJson['page_type'] : '',
    );
  }
}

class APIRegularSearchSuggestedExtendedPageDetails{
  String searchSuggestedPageDetailsDescription;

  APIRegularSearchSuggestedExtendedPageDetails({required this.searchSuggestedPageDetailsDescription});

  factory APIRegularSearchSuggestedExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularSearchSuggestedExtendedPageDetails(
      searchSuggestedPageDetailsDescription: parsedJson['description'] != null ? parsedJson['description'] : '',
    );
  }
}
