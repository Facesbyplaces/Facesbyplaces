import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularSearchBLMMemorialMain> apiRegularSearchBLM({required String keywords, required int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/search/memorials?keywords=$keywords&page=blm&page=$page',
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
    return APIRegularSearchBLMMemorialMain.fromJson(newData);
  }else{
    throw Exception('Failed to get the blm list');
  }


  // final http.Response response = await http.get(
  //   // Uri.http('http://fbp.dev1.koda.ws/api/v1/search/memorials?keywords=$keywords&page=blm&page=$page', ''),
  //   Uri.http('fbp.dev1.koda.ws', '/api/v1/search/memorials', {'page' : '$page', 'keywords': '$keywords'}),
  //   headers: <String, String>{
  //     'Content-Type': 'application/json',
  //     'access-token': getAccessToken,
  //     'uid': getUID,
  //     'client': getClient,
  //   }
  // );

  // print('The status code of blm in alm is ${response.statusCode}');

  // if(response.statusCode == 200){
  //   var newValue = json.decode(response.body);
  //   return APIRegularSearchBLMMemorialMain.fromJson(newValue);
  // }else{
  //   throw Exception('Failed to get the memorials.');
  // }
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