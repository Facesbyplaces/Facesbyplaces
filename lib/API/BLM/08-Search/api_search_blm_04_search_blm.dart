import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIBLMSearchMemorialMain> apiBLMSearchBLM({required String keywords, required int page}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('https://www.facesbyplaces.com/api/v1/search/memorials?keywords=$keywords&page=$page',
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
    return APIBLMSearchMemorialMain.fromJson(newData);
  }else{
    throw Exception('Failed to get the blm');
  }
}

class APIBLMSearchMemorialMain{
  int blmItemsRemaining;
  List<APIBLMSearchMemorialPage> blmMemorialList;
  APIBLMSearchMemorialMain({required this.blmItemsRemaining, required this.blmMemorialList});

  factory APIBLMSearchMemorialMain.fromJson(Map<String, dynamic> parsedJson){
    var memorialList = parsedJson['memorials'] as List;
    List<APIBLMSearchMemorialPage> newMemorialList = memorialList.map((e) => APIBLMSearchMemorialPage.fromJson(e)).toList();

    return APIBLMSearchMemorialMain(
      blmItemsRemaining: parsedJson['itemsremaining'],
      blmMemorialList: newMemorialList,
    );
  }
}

class APIBLMSearchMemorialPage{
  int searchMemorialId;
  APIBLMSearchMemorialExtended searchMemorialPage;
  APIBLMSearchMemorialPage({required this.searchMemorialId, required this.searchMemorialPage});

  factory APIBLMSearchMemorialPage.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMSearchMemorialPage(
      searchMemorialId: parsedJson['id'],
      searchMemorialPage: APIBLMSearchMemorialExtended.fromJson(parsedJson['page']),
    );
  }
}

class APIBLMSearchMemorialExtended{
  int searchMemorialId;
  String searchMemorialName;
  APIBLMSearchMemorialExtendedPageDetails searchMemorialDetails;
  dynamic searchMemorialProfileImage;
  String searchMemorialRelationship;
  bool searchMemorialManage;
  bool searchMemorialFamOrFriends;
  bool searchMemorialFollower;
  String searchMemorialPageType;
  APIBLMSearchMemorialExtended({required this.searchMemorialId, required this.searchMemorialName, required this.searchMemorialDetails, required this.searchMemorialProfileImage, required this.searchMemorialRelationship, required this.searchMemorialManage, required this.searchMemorialFamOrFriends, required this.searchMemorialFollower, required this.searchMemorialPageType});

  factory APIBLMSearchMemorialExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMSearchMemorialExtended(
      searchMemorialId: parsedJson['id'],
      searchMemorialName: parsedJson['name'] ?? '',
      searchMemorialDetails: APIBLMSearchMemorialExtendedPageDetails.fromJson(parsedJson['details']),
      searchMemorialProfileImage: parsedJson['profileImage'],
      searchMemorialRelationship: parsedJson['relationship'] ?? '',
      searchMemorialManage: parsedJson['manage'],
      searchMemorialFamOrFriends: parsedJson['famOrFriends'],
      searchMemorialFollower: parsedJson['follower'],
      searchMemorialPageType: parsedJson['page_type'] ?? '',
    );
  }
}

class APIBLMSearchMemorialExtendedPageDetails{
  String searchMemorialPageDetailsDescription;
  APIBLMSearchMemorialExtendedPageDetails({required this.searchMemorialPageDetailsDescription});

  factory APIBLMSearchMemorialExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMSearchMemorialExtendedPageDetails(
      searchMemorialPageDetailsDescription: parsedJson['description'] ?? '',
    );
  }
}