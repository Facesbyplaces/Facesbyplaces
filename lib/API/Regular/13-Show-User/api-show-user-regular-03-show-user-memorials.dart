import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowUserMemorialsMain> apiRegularShowUserMemorials({int userId, int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/users/memorials?user_id=$userId&page=$page&account_type=2',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularShowUserMemorialsMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the memorials');
  }
}

class APIRegularShowUserMemorialsMain{
  int almOwnedItemsRemaining;
  int almFollowedItemsRemaining;
  List<APIRegularShowUserMemorialsExtended> almOwned;
  List<APIRegularShowUserMemorialsExtended> almFollowed;

  APIRegularShowUserMemorialsMain({this.almOwnedItemsRemaining, this.almFollowedItemsRemaining, this.almOwned, this.almFollowed});

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

  APIRegularShowUserMemorialsExtended({this.showUserMemorialsPage});

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
  dynamic showUserMemorialsPageBackgroundImage;
  dynamic showUserMemorialsPageProfileImage;
  dynamic showUserMemorialsPageImagesOrVideos;
  String showUserMemorialsPageRelationship;
  APIRegularShowUserMemorialsExtendedPageCreator showUserMemorialsPageCreator;
  bool showUserMemorialsPageManage;
  bool showUserMemorialsPageFamOrFriends;
  bool showUserMemorialsPageFollower;
  String showUserMemorialsPageType;
  String showUserMemorialsPagePrivacy;

  APIRegularShowUserMemorialsExtendedPage({this.showUserMemorialsPageId, this.showUserMemorialsPageName, this.showUserMemorialsPageDetails, this.showUserMemorialsPageBackgroundImage, this.showUserMemorialsPageProfileImage, this.showUserMemorialsPageImagesOrVideos, this.showUserMemorialsPageRelationship, this.showUserMemorialsPageCreator, this.showUserMemorialsPageManage, this.showUserMemorialsPageFamOrFriends, this.showUserMemorialsPageFollower, this.showUserMemorialsPageType, this.showUserMemorialsPagePrivacy});

  factory APIRegularShowUserMemorialsExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowUserMemorialsExtendedPage(
      showUserMemorialsPageId: parsedJson['id'],
      showUserMemorialsPageName: parsedJson['name'],
      showUserMemorialsPageDetails: APIRegularShowUserMemorialsExtendedPageDetails.fromJson(parsedJson['details']),
      showUserMemorialsPageBackgroundImage: parsedJson['backgroundImage'],
      showUserMemorialsPageProfileImage: parsedJson['profileImage'],
      showUserMemorialsPageImagesOrVideos: parsedJson['imagesOrVideos'],
      showUserMemorialsPageRelationship: parsedJson['relationship'],
      showUserMemorialsPageCreator: APIRegularShowUserMemorialsExtendedPageCreator.fromJson(parsedJson['page_creator']),
      showUserMemorialsPageManage: parsedJson['manage'],
      showUserMemorialsPageFamOrFriends: parsedJson['famOrFriends'],
      showUserMemorialsPageFollower: parsedJson['follower'],
      showUserMemorialsPageType: parsedJson['page_type'],
      showUserMemorialsPagePrivacy: parsedJson['privacy'],
    );
  }
}

class APIRegularShowUserMemorialsExtendedPageDetails{
  String showUserMemorialsPageDetailsDescription;
  String showUserMemorialsPageDetailsDob;
  String showUserMemorialsPageDetailsRip;

  APIRegularShowUserMemorialsExtendedPageDetails({this.showUserMemorialsPageDetailsDescription, this.showUserMemorialsPageDetailsDob, this.showUserMemorialsPageDetailsRip,});
  
  factory APIRegularShowUserMemorialsExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowUserMemorialsExtendedPageDetails(
      showUserMemorialsPageDetailsDescription: parsedJson['description'],
      showUserMemorialsPageDetailsDob: parsedJson['dob'],
      showUserMemorialsPageDetailsRip: parsedJson['rip'],
    );
  }
}

class APIRegularShowUserMemorialsExtendedPageCreator{
  int showUserMemorialsPageCreatorId;
  String showUserMemorialsPageCreatorFirstName;
  String showUserMemorialsPageCreatorLastName;
  String showUserMemorialsPageCreatorPhoneNumber;
  String showUserMemorialsPageCreatorEmail;
  String showUserMemorialsPageCreatorUserName;
  dynamic showUserMemorialsPageCreatorImage;

  APIRegularShowUserMemorialsExtendedPageCreator({this.showUserMemorialsPageCreatorId, this.showUserMemorialsPageCreatorFirstName, this.showUserMemorialsPageCreatorLastName, this.showUserMemorialsPageCreatorPhoneNumber, this.showUserMemorialsPageCreatorEmail, this.showUserMemorialsPageCreatorUserName, this.showUserMemorialsPageCreatorImage});

  factory APIRegularShowUserMemorialsExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowUserMemorialsExtendedPageCreator(
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
