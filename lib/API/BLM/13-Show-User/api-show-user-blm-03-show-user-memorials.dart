import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowUserMemorialsMain> apiBLMShowUserMemorials({int userId, int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/users/memorials?user_id=$userId&page=$page&account_type=1',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMShowUserMemorialsMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the memorials');
  }
}

class APIBLMShowUserMemorialsMain{
  int blmOwnedItemsRemaining;
  int blmFollowedItemsRemaining;
  List<APIBLMShowUserMemorialsExtended> blmOwned;
  List<APIBLMShowUserMemorialsExtended> blmFollowed;

  APIBLMShowUserMemorialsMain({this.blmOwnedItemsRemaining, this.blmFollowedItemsRemaining, this.blmOwned, this.blmFollowed});

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

  APIBLMShowUserMemorialsExtended({this.showUserMemorialsPage});

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

  APIBLMShowUserMemorialsExtendedPage({this.showUserMemorialsPageId, this.showUserMemorialsPageName, this.showUserMemorialsPageDetails, this.showUserMemorialsPageBackgroundImage, this.showUserMemorialsPageProfileImage, this.showUserMemorialsPageImagesOrVideos, this.showUserMemorialsPageRelationship, this.showUserMemorialsPageCreator, this.showUserMemorialsPageManage, this.showUserMemorialsPageFamOrFriends, this.showUserMemorialsPageFollower, this.showUserMemorialsPageType, this.showUserMemorialsPagePrivacy});

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

  APIBLMShowUserMemorialsExtendedPageDetails({this.showUserMemorialsPageDetailsDescription, this.showUserMemorialsPageDetailsDob, this.showUserMemorialsPageDetailsRip,});
  
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

  APIBLMShowUserMemorialsExtendedPageCreator({this.showUserMemorialsPageCreatorId, this.showUserMemorialsPageCreatorFirstName, this.showUserMemorialsPageCreatorLastName, this.showUserMemorialsPageCreatorPhoneNumber, this.showUserMemorialsPageCreatorEmail, this.showUserMemorialsPageCreatorUserName, this.showUserMemorialsPageCreatorImage});

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
