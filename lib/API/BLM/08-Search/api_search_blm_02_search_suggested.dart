import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIBLMSearchSuggestedMain> apiBLMSearchSuggested({required int page}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  // var response = await dioRequest.get('https://facesbyplaces.com/api/v1/search/suggested/?page=$page',
  var response = await dioRequest.get('https://www.facesbyplaces.com/api/v1/search/suggested/?page=$page',
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
    return APIBLMSearchSuggestedMain.fromJson(newData);
  }else{
    throw Exception('Failed to get the suggested');
  }
}

class APIBLMSearchSuggestedMain{
  int blmItemsRemaining;
  List<APIBLMSearchSuggestedExtended> blmPages;
  APIBLMSearchSuggestedMain({required this.blmItemsRemaining, required this.blmPages});

  factory APIBLMSearchSuggestedMain.fromJson(Map<String, dynamic> parsedJson){
    var newList = parsedJson['pages'] as List;
    List<APIBLMSearchSuggestedExtended> pagesList = newList.map((i) => APIBLMSearchSuggestedExtended.fromJson(i)).toList();

    return APIBLMSearchSuggestedMain(
      blmItemsRemaining: parsedJson['itemsRemaining'],
      blmPages: pagesList,
    );
  }
}

class APIBLMSearchSuggestedExtended{
  int searchSuggestedId;
  APIBLMSearchSuggestedExtendedPage searchSuggestedPage;
  APIBLMSearchSuggestedExtended({required this.searchSuggestedId, required this.searchSuggestedPage});

  factory APIBLMSearchSuggestedExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMSearchSuggestedExtended(
      searchSuggestedId: parsedJson['id'],
      searchSuggestedPage: APIBLMSearchSuggestedExtendedPage.fromJson(parsedJson['page'])
    );
  }
}

class APIBLMSearchSuggestedExtendedPage{
  int searchSuggestedPageId;
  String searchSuggestedPageName;
  APIBLMSearchSuggestedPageDetails searchSuggestedPageDetails;
  String searchSuggestedPageProfileImage;
  String searchSuggestedPageRelationship;
  bool searchSuggestedPageManage;
  bool searchSuggestedPageFamOrFriends;
  bool searchSuggestedPageFollower;
  String searchSuggestedPagePageType;
  APIBLMSearchSuggestedExtendedPage({required this.searchSuggestedPageId, required this.searchSuggestedPageName, required this.searchSuggestedPageDetails, required this.searchSuggestedPageProfileImage, required this.searchSuggestedPageRelationship, required this.searchSuggestedPageManage, required this.searchSuggestedPageFamOrFriends, required this.searchSuggestedPageFollower, required this.searchSuggestedPagePageType});

  factory APIBLMSearchSuggestedExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMSearchSuggestedExtendedPage(
      searchSuggestedPageId: parsedJson['id'],
      searchSuggestedPageName: parsedJson['name'] ?? '',
      searchSuggestedPageDetails: APIBLMSearchSuggestedPageDetails.fromJson(parsedJson['details']),
      searchSuggestedPageProfileImage: parsedJson['profileImage'] ?? '',
      searchSuggestedPageRelationship: parsedJson['relationship'] ?? '',
      searchSuggestedPageManage: parsedJson['manage'],
      searchSuggestedPageFamOrFriends: parsedJson['famOrFriends'],
      searchSuggestedPageFollower: parsedJson['follower'],
      searchSuggestedPagePageType: parsedJson['page_type'] ?? '',
    );
  }
}

class APIBLMSearchSuggestedPageDetails{
  String searchSuggestedPageDetailsDescription;
  APIBLMSearchSuggestedPageDetails({required this.searchSuggestedPageDetailsDescription});

  factory APIBLMSearchSuggestedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMSearchSuggestedPageDetails(
      searchSuggestedPageDetailsDescription: parsedJson['description'] ?? '',
    );
  }
}