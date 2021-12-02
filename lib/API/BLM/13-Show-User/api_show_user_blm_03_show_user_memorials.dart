import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIBLMShowUserMemorialsMain> apiBLMShowUserMemorials({required int userId, required int accountType, required int page}) async{
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

  var response = await dioRequest.get('https://www.facesbyplaces.com/api/v1/users/memorials?user_id=$userId&page=$page&account_type=$accountType',
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
    return APIBLMShowUserMemorialsMain.fromJson(newData);
  }else{
    throw Exception('Failed to get the memorials');
  }
}

class APIBLMShowUserMemorialsMain{
  int blmOwnedItemsRemaining;
  int blmFollowedItemsRemaining;
  List<APIBLMShowUserMemorialsExtended> blmOwned;
  List<APIBLMShowUserMemorialsExtended> blmFollowed;
  APIBLMShowUserMemorialsMain({required this.blmOwnedItemsRemaining, required this.blmFollowedItemsRemaining, required this.blmOwned, required this.blmFollowed});

  factory APIBLMShowUserMemorialsMain.fromJson(Map<String, dynamic> parsedJson){
    var ownedList = parsedJson['owned'] as List;
    var followedList = parsedJson['followed'] as List;

    List<APIBLMShowUserMemorialsExtended> newOwnedList = ownedList.map((e) => APIBLMShowUserMemorialsExtended.fromJson(e)).toList();
    List<APIBLMShowUserMemorialsExtended> newFollowedList = followedList.map((e) => APIBLMShowUserMemorialsExtended.fromJson(e)).toList();

    return APIBLMShowUserMemorialsMain(
      blmOwnedItemsRemaining: parsedJson['ownedItemsRemaining'],
      blmFollowedItemsRemaining: parsedJson['followedItemsRemaining'],
      blmOwned: newOwnedList,
      blmFollowed: newFollowedList,
    );
  }
}

class APIBLMShowUserMemorialsExtended{
  APIBLMShowUserMemorialsExtendedPage showUserMemorialsPage;
  APIBLMShowUserMemorialsExtended({required this.showUserMemorialsPage});

  factory APIBLMShowUserMemorialsExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowUserMemorialsExtended(
      showUserMemorialsPage: APIBLMShowUserMemorialsExtendedPage.fromJson(parsedJson['page']),
    );
  }
}

class APIBLMShowUserMemorialsExtendedPage{
  int showUserMemorialsPageId;
  String showUserMemorialsPageName;
  APIBLMShowUserMemorialsExtendedPageDetails showUserMemorialsPageDetails;
  String showUserMemorialsPageProfileImage;
  String showUserMemorialsPageRelationship;
  bool showUserMemorialsPageManage;
  bool showUserMemorialsPageFamOrFriends;
  bool showUserMemorialsPageFollower;
  String showUserMemorialsPageType;
  APIBLMShowUserMemorialsExtendedPage({required this.showUserMemorialsPageId, required this.showUserMemorialsPageName, required this.showUserMemorialsPageDetails, required this.showUserMemorialsPageProfileImage, required this.showUserMemorialsPageRelationship, required this.showUserMemorialsPageManage, required this.showUserMemorialsPageFamOrFriends, required this.showUserMemorialsPageFollower, required this.showUserMemorialsPageType,});

  factory APIBLMShowUserMemorialsExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowUserMemorialsExtendedPage(
      showUserMemorialsPageId: parsedJson['id'],
      showUserMemorialsPageName: parsedJson['name'] ?? '',
      showUserMemorialsPageDetails: APIBLMShowUserMemorialsExtendedPageDetails.fromJson(parsedJson['details']),
      showUserMemorialsPageProfileImage: parsedJson['profileImage'] ?? '',
      showUserMemorialsPageRelationship: parsedJson['relationship'] ?? '',
      showUserMemorialsPageManage: parsedJson['manage'],
      showUserMemorialsPageFamOrFriends: parsedJson['famOrFriends'],
      showUserMemorialsPageFollower: parsedJson['follower'],
      showUserMemorialsPageType: parsedJson['page_type'] ?? '',
    );
  }
}

class APIBLMShowUserMemorialsExtendedPageDetails{
  String showUserMemorialsPageDetailsDescription;
  APIBLMShowUserMemorialsExtendedPageDetails({required this.showUserMemorialsPageDetailsDescription});
  
  factory APIBLMShowUserMemorialsExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowUserMemorialsExtendedPageDetails(
      showUserMemorialsPageDetailsDescription: parsedJson['description'] ?? '',
    );
  }
}