import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

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

  // final http.Response response = await http.get(
  //   Uri.http('http://fbp.dev1.koda.ws/api/v1/users/memorials?user_id=$userId&page=$page&account_type=1', ''),
  //   headers: <String, String>{
  //     'Content-Type': 'application/json',
  //     'access-token': getAccessToken,
  //     'uid': getUID,
  //     'client': getClient,
  //   }
  // );

  // if(response.statusCode == 200){
  //   var newValue = json.decode(response.body);
  //   return APIBLMShowUserMemorialsMain.fromJson(newValue);
  // }else{
  //   throw Exception('Failed to get the memorials');
  // }
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
  dynamic showUserMemorialsPageBackgroundImage;
  dynamic showUserMemorialsPageProfileImage;
  dynamic showUserMemorialsPageImagesOrVideos;
  String showUserMemorialsPageRelationship;
  APIBLMShowUserMemorialsExtendedPageCreator showUserMemorialsPageCreator;
  bool showUserMemorialsPageManage;
  bool showUserMemorialsPageFamOrFriends;
  bool showUserMemorialsPageFollower;
  String showUserMemorialsPageType;
  String showUserMemorialsPagePrivacy;

  APIBLMShowUserMemorialsExtendedPage({required this.showUserMemorialsPageId, required this.showUserMemorialsPageName, required this.showUserMemorialsPageDetails, required this.showUserMemorialsPageBackgroundImage, required this.showUserMemorialsPageProfileImage, required this.showUserMemorialsPageImagesOrVideos, required this.showUserMemorialsPageRelationship, required this.showUserMemorialsPageCreator, required this.showUserMemorialsPageManage, required this.showUserMemorialsPageFamOrFriends, required this.showUserMemorialsPageFollower, required this.showUserMemorialsPageType, required this.showUserMemorialsPagePrivacy});

  factory APIBLMShowUserMemorialsExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowUserMemorialsExtendedPage(
      showUserMemorialsPageId: parsedJson['id'],
      showUserMemorialsPageName: parsedJson['name'],
      showUserMemorialsPageDetails: APIBLMShowUserMemorialsExtendedPageDetails.fromJson(parsedJson['details']),
      showUserMemorialsPageBackgroundImage: parsedJson['backgroundImage'],
      showUserMemorialsPageProfileImage: parsedJson['profileImage'],
      showUserMemorialsPageImagesOrVideos: parsedJson['imagesOrVideos'],
      showUserMemorialsPageRelationship: parsedJson['relationship'],
      showUserMemorialsPageCreator: APIBLMShowUserMemorialsExtendedPageCreator.fromJson(parsedJson['page_creator']),
      showUserMemorialsPageManage: parsedJson['manage'],
      showUserMemorialsPageFamOrFriends: parsedJson['famOrFriends'],
      showUserMemorialsPageFollower: parsedJson['follower'],
      showUserMemorialsPageType: parsedJson['page_type'],
      showUserMemorialsPagePrivacy: parsedJson['privacy'],
    );
  }
}

class APIBLMShowUserMemorialsExtendedPageDetails{
  String showUserMemorialsPageDetailsDescription;
  String showUserMemorialsPageDetailsDob;
  String showUserMemorialsPageDetailsRip;

  APIBLMShowUserMemorialsExtendedPageDetails({required this.showUserMemorialsPageDetailsDescription, required this.showUserMemorialsPageDetailsDob, required this.showUserMemorialsPageDetailsRip,});
  
  factory APIBLMShowUserMemorialsExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowUserMemorialsExtendedPageDetails(
      showUserMemorialsPageDetailsDescription: parsedJson['description'],
      showUserMemorialsPageDetailsDob: parsedJson['dob'],
      showUserMemorialsPageDetailsRip: parsedJson['rip'],
    );
  }
}

class APIBLMShowUserMemorialsExtendedPageCreator{
  int showUserMemorialsPageCreatorId;
  String showUserMemorialsPageCreatorFirstName;
  String showUserMemorialsPageCreatorLastName;
  String showUserMemorialsPageCreatorPhoneNumber;
  String showUserMemorialsPageCreatorEmail;
  String showUserMemorialsPageCreatorUserName;
  dynamic showUserMemorialsPageCreatorImage;

  APIBLMShowUserMemorialsExtendedPageCreator({required this.showUserMemorialsPageCreatorId, required this.showUserMemorialsPageCreatorFirstName, required this.showUserMemorialsPageCreatorLastName, required this.showUserMemorialsPageCreatorPhoneNumber, required this.showUserMemorialsPageCreatorEmail, required this.showUserMemorialsPageCreatorUserName, required this.showUserMemorialsPageCreatorImage});

  factory APIBLMShowUserMemorialsExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowUserMemorialsExtendedPageCreator(
      showUserMemorialsPageCreatorId: parsedJson['id'],
      showUserMemorialsPageCreatorFirstName: parsedJson['first_name'],
      showUserMemorialsPageCreatorLastName: parsedJson['last_name'],
      showUserMemorialsPageCreatorPhoneNumber: parsedJson['phone_number'],
      showUserMemorialsPageCreatorEmail: parsedJson['email'],
      showUserMemorialsPageCreatorUserName: parsedJson['username'],
      showUserMemorialsPageCreatorImage: parsedJson['image']
    );
  }
}
