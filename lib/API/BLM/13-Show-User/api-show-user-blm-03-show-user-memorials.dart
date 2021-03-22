import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIBLMShowUserMemorialsMain> apiBLMShowUserMemorials({required int userId, required int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/users/memorials?user_id=$userId&page=$page&account_type=1',
    options: Options(
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  print('The status code of user memorials is ${response.statusCode}');

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
      showUserMemorialsPageName: parsedJson['name'] != null ? parsedJson['name'] : '',
      showUserMemorialsPageDetails: APIBLMShowUserMemorialsExtendedPageDetails.fromJson(parsedJson['details']),
      showUserMemorialsPageProfileImage: parsedJson['profileImage'] != null ? parsedJson['profileImage'] : '',
      showUserMemorialsPageRelationship: parsedJson['relationship'] != null ? parsedJson['relationship'] : '',
      showUserMemorialsPageManage: parsedJson['manage'],
      showUserMemorialsPageFamOrFriends: parsedJson['famOrFriends'],
      showUserMemorialsPageFollower: parsedJson['follower'],
      showUserMemorialsPageType: parsedJson['page_type'] != null ? parsedJson['page_type'] : '',
    );
  }
}

class APIBLMShowUserMemorialsExtendedPageDetails{
  String showUserMemorialsPageDetailsDescription;

  APIBLMShowUserMemorialsExtendedPageDetails({required this.showUserMemorialsPageDetailsDescription});
  
  factory APIBLMShowUserMemorialsExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowUserMemorialsExtendedPageDetails(
      showUserMemorialsPageDetailsDescription: parsedJson['description'] != null ? parsedJson['description'] : '',
    );
  }
}