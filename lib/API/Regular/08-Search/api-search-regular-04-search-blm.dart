import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularSearchBLMMemorialMain> apiRegularSearchBLM({required String keywords, required int page}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://45.33.66.25:3001/api/v1/search/memorials?keywords=$keywords&page=$page',
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

  print('The status code of regular search blm is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIRegularSearchBLMMemorialMain.fromJson(newData);
  }else{
    throw Exception('Failed to get the blm list');
  }
}

class APIRegularSearchBLMMemorialMain{
  int almItemsRemaining;
  List<APIRegularSearchBLMMemorialExtended> almMemorialList;
  APIRegularSearchBLMMemorialMain({required this.almItemsRemaining, required this.almMemorialList});

  factory APIRegularSearchBLMMemorialMain.fromJson(Map<String, dynamic> parsedJson){
    var memorialList = parsedJson['memorials'] as List;
    List<APIRegularSearchBLMMemorialExtended> newMemorialList = memorialList.map((e) => APIRegularSearchBLMMemorialExtended.fromJson(e)).toList();

    return APIRegularSearchBLMMemorialMain(
      almItemsRemaining: parsedJson['itemsremaining'],
      almMemorialList: newMemorialList,
    );
  }
}

class APIRegularSearchBLMMemorialExtended{
  int searchBLMMemorialId;
  APIRegularSearchBLMMemorialExtendedPage searchBLMMemorialPage;
  APIRegularSearchBLMMemorialExtended({required this.searchBLMMemorialId, required this.searchBLMMemorialPage});

  factory APIRegularSearchBLMMemorialExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularSearchBLMMemorialExtended(
      searchBLMMemorialId: parsedJson['id'],
      searchBLMMemorialPage: APIRegularSearchBLMMemorialExtendedPage.fromJson(parsedJson['page']),
    );
  }
}

class APIRegularSearchBLMMemorialExtendedPage{
  int searchBLMMemorialPageId;
  String searchBLMMemorialPageName;
  APIRegularSearchBLMMemorialExtendedPageDetails searchBLMMemorialPageDetails;
  String searchBLMMemorialPageProfileImage;
  String searchBLMMemorialPageRelationship;
  bool searchBLMMemorialPageManage;
  bool searchBLMMemorialPageFamOrFriends;
  bool searchBLMMemorialPageFollower;
  String searchBLMMemorialPagePageType;
  APIRegularSearchBLMMemorialExtendedPage({required this.searchBLMMemorialPageId, required this.searchBLMMemorialPageName, required this.searchBLMMemorialPageDetails, required this.searchBLMMemorialPageProfileImage, required this.searchBLMMemorialPageRelationship, required this.searchBLMMemorialPageManage, required this.searchBLMMemorialPageFamOrFriends, required this.searchBLMMemorialPageFollower, required this.searchBLMMemorialPagePageType});

  factory APIRegularSearchBLMMemorialExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularSearchBLMMemorialExtendedPage(
      searchBLMMemorialPageId: parsedJson['id'],
      searchBLMMemorialPageName: parsedJson['name'],
      searchBLMMemorialPageDetails: APIRegularSearchBLMMemorialExtendedPageDetails.fromJson(parsedJson['details']),
      searchBLMMemorialPageProfileImage: parsedJson['profileImage'] != null ? parsedJson['profileImage'] : '',
      searchBLMMemorialPageRelationship: parsedJson['relationship'] != null ? parsedJson['relationship'] : '',
      searchBLMMemorialPageManage: parsedJson['manage'],
      searchBLMMemorialPageFamOrFriends: parsedJson['famOrFriends'],
      searchBLMMemorialPageFollower: parsedJson['follower'],
      searchBLMMemorialPagePageType: parsedJson['page_type'] != null ? parsedJson['page_type'] : '',
    );
  }
}

class APIRegularSearchBLMMemorialExtendedPageDetails{
  String searchBLMMemorialPageDetailsDescription;
  APIRegularSearchBLMMemorialExtendedPageDetails({required this.searchBLMMemorialPageDetailsDescription});

  factory APIRegularSearchBLMMemorialExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularSearchBLMMemorialExtendedPageDetails(
      searchBLMMemorialPageDetailsDescription: parsedJson['description'] != null ? parsedJson['description'] : '',
    );
  }
}