import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularShowUserMemorialsMain> apiRegularShowUserMemorials({required int userId, required int accountType, required int page}) async{
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

  var response = await dioRequest.get('http://facesbyplaces.com/api/v1/users/memorials?user_id=$userId&page=$page&account_type=$accountType',
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

  print('The status code of regular show user memorials is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIRegularShowUserMemorialsMain.fromJson(newData);
  }else{
    throw Exception('Failed to get the memorials');
  }
}

class APIRegularShowUserMemorialsMain{
  int almOwnedItemsRemaining;
  int almFollowedItemsRemaining;
  List<APIRegularShowUserMemorialsExtended> almOwned;
  List<APIRegularShowUserMemorialsExtended> almFollowed;
  APIRegularShowUserMemorialsMain({required this.almOwnedItemsRemaining, required this.almFollowedItemsRemaining, required this.almOwned, required this.almFollowed});

  factory APIRegularShowUserMemorialsMain.fromJson(Map<String, dynamic> parsedJson){
    var ownedList = parsedJson['owned'] as List;
    var followedList = parsedJson['followed'] as List;

    List<APIRegularShowUserMemorialsExtended> newOwnedList = ownedList.map((e) => APIRegularShowUserMemorialsExtended.fromJson(e)).toList();
    List<APIRegularShowUserMemorialsExtended> newFollowedList = followedList.map((e) => APIRegularShowUserMemorialsExtended.fromJson(e)).toList();

    return APIRegularShowUserMemorialsMain(
      almOwnedItemsRemaining: parsedJson['ownedItemsRemaining'],
      almFollowedItemsRemaining: parsedJson['followedItemsRemaining'],
      almOwned: newOwnedList,
      almFollowed: newFollowedList,
    );
  }
}

class APIRegularShowUserMemorialsExtended{
  APIRegularShowUserMemorialsExtendedPage showUserMemorialsPage;
  APIRegularShowUserMemorialsExtended({required this.showUserMemorialsPage});

  factory APIRegularShowUserMemorialsExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowUserMemorialsExtended(
      showUserMemorialsPage: APIRegularShowUserMemorialsExtendedPage.fromJson(parsedJson['page']),
    );
  }
}

class APIRegularShowUserMemorialsExtendedPage{
  int showUserMemorialsPageId;
  String showUserMemorialsPageName;
  APIRegularShowUserMemorialsExtendedPageDetails showUserMemorialsPageDetails;
  String showUserMemorialsPageProfileImage;
  String showUserMemorialsPageRelationship;
  bool showUserMemorialsPageManage;
  bool showUserMemorialsPageFamOrFriends;
  bool showUserMemorialsPageFollower;
  String showUserMemorialsPageType;
  APIRegularShowUserMemorialsExtendedPage({required this.showUserMemorialsPageId, required this.showUserMemorialsPageName, required this.showUserMemorialsPageDetails, required this.showUserMemorialsPageProfileImage, required this.showUserMemorialsPageRelationship, required this.showUserMemorialsPageManage, required this.showUserMemorialsPageFamOrFriends, required this.showUserMemorialsPageFollower, required this.showUserMemorialsPageType,});

  factory APIRegularShowUserMemorialsExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowUserMemorialsExtendedPage(
      showUserMemorialsPageId: parsedJson['id'],
      showUserMemorialsPageName: parsedJson['name'] != null ? parsedJson['name'] : '',
      showUserMemorialsPageDetails: APIRegularShowUserMemorialsExtendedPageDetails.fromJson(parsedJson['details']),
      showUserMemorialsPageProfileImage: parsedJson['profileImage'] != null ? parsedJson['profileImage'] : '',
      showUserMemorialsPageRelationship: parsedJson['relationship'] != null ? parsedJson['relationship'] : '',
      showUserMemorialsPageManage: parsedJson['manage'],
      showUserMemorialsPageFamOrFriends: parsedJson['famOrFriends'],
      showUserMemorialsPageFollower: parsedJson['follower'],
      showUserMemorialsPageType: parsedJson['page_type'] != null ? parsedJson['page_type'] : '',
    );
  }
}

class APIRegularShowUserMemorialsExtendedPageDetails{
  String showUserMemorialsPageDetailsDescription;
  APIRegularShowUserMemorialsExtendedPageDetails({required this.showUserMemorialsPageDetailsDescription,});
  
  factory APIRegularShowUserMemorialsExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowUserMemorialsExtendedPageDetails(
      showUserMemorialsPageDetailsDescription: parsedJson['description'] != null ? parsedJson['description'] : '',
    );
  }
}