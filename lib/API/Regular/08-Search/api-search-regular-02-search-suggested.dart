import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularSearchSuggestedMain> apiRegularSearchSuggested({int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/search/suggested/?page=$page',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The status code of suggested in alm is ${response.statusCode}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularSearchSuggestedMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the feed');
  }
}

class APIRegularSearchSuggestedMain{
  int almItemsRemaining;
  List<APIRegularSearchSuggestedExtended> almSearchSuggestedPages;

  APIRegularSearchSuggestedMain({this.almItemsRemaining, this.almSearchSuggestedPages});

  factory APIRegularSearchSuggestedMain.fromJson(Map<String, dynamic> parsedJson){

    var newList = parsedJson['pages'] as List;
    List<APIRegularSearchSuggestedExtended> pagesList = newList.map((i) => APIRegularSearchSuggestedExtended.fromJson(i)).toList();

    return APIRegularSearchSuggestedMain(
      almItemsRemaining: parsedJson['itemsRemaining'],
      almSearchSuggestedPages: pagesList,
    );
  }
}

class APIRegularSearchSuggestedExtended{
  int searchSuggestedId;
  APIRegularSearchSuggestedExtendedPage searchSuggestedPage;

  APIRegularSearchSuggestedExtended({this.searchSuggestedId, this.searchSuggestedPage});

  factory APIRegularSearchSuggestedExtended.fromJson(Map<String, dynamic> parsedJson){
    
    return APIRegularSearchSuggestedExtended(
      searchSuggestedId: parsedJson['id'],
      searchSuggestedPage: APIRegularSearchSuggestedExtendedPage.fromJson(parsedJson['page'])
    );
  }
}

class APIRegularSearchSuggestedExtendedPage{
  int searchSuggestedPageId;
  String searchSuggestedPageName;
  APIRegularSearchSuggestedExtendedPageDetails searchSuggestedPageDetails;
  dynamic searchSuggestedPageBackgroundImage;
  dynamic searchSuggestedPageProfileImage;
  dynamic searchSuggestedPageImagesOrVideos;
  String searchSuggestedPageRelationship;
  APIRegularSearchSuggestedExtendedPageCreator searchSuggestedPagePageCreator;
  bool searchSuggestedPageManage;
  bool searchSuggestedPageFamOrFriends;
  bool searchSuggestedPageFollower;
  String searchSuggestedPagePageType;
  String searchSuggestedPagePrivacy;

  APIRegularSearchSuggestedExtendedPage({this.searchSuggestedPageId, this.searchSuggestedPageName, this.searchSuggestedPageDetails, this.searchSuggestedPageBackgroundImage, this.searchSuggestedPageProfileImage, this.searchSuggestedPageImagesOrVideos, this.searchSuggestedPageRelationship, this.searchSuggestedPagePageCreator, this.searchSuggestedPageManage, this.searchSuggestedPageFamOrFriends, this.searchSuggestedPageFollower, this.searchSuggestedPagePageType, this.searchSuggestedPagePrivacy});

  factory APIRegularSearchSuggestedExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularSearchSuggestedExtendedPage(
      searchSuggestedPageId: parsedJson['id'],
      searchSuggestedPageName: parsedJson['name'],
      searchSuggestedPageDetails: APIRegularSearchSuggestedExtendedPageDetails.fromJson(parsedJson['details']),
      searchSuggestedPageBackgroundImage: parsedJson['backgroundImage'],
      searchSuggestedPageProfileImage: parsedJson['profileImage'],
      searchSuggestedPageImagesOrVideos: parsedJson['imagesOrVideos'],
      searchSuggestedPageRelationship: parsedJson['relationship'],
      searchSuggestedPagePageCreator: APIRegularSearchSuggestedExtendedPageCreator.fromJson(parsedJson['page_creator']),
      searchSuggestedPageManage: parsedJson['manage'],
      searchSuggestedPageFamOrFriends: parsedJson['famOrFriends'],
      searchSuggestedPageFollower: parsedJson['follower'],
      searchSuggestedPagePageType: parsedJson['page_type'],
      searchSuggestedPagePrivacy: parsedJson['privacy'],
    );
  }
}

class APIRegularSearchSuggestedExtendedPageDetails{
  String searchSuggestedPageDetailsDescription;
  String searchSuggestedPageDetailsLocation;
  String searchSuggestedPageDetailsPrecinct;
  String searchSuggestedPageDetailsDob;
  String searchSuggestedPageDetailsRip;
  String searchSuggestedPageDetailsState;
  String searchSuggestedPageDetailsCountry;

  APIRegularSearchSuggestedExtendedPageDetails({this.searchSuggestedPageDetailsDescription, this.searchSuggestedPageDetailsLocation, this.searchSuggestedPageDetailsPrecinct, this.searchSuggestedPageDetailsDob, this.searchSuggestedPageDetailsRip, this.searchSuggestedPageDetailsState, this.searchSuggestedPageDetailsCountry});

  factory APIRegularSearchSuggestedExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularSearchSuggestedExtendedPageDetails(
      searchSuggestedPageDetailsDescription: parsedJson['description'],
      searchSuggestedPageDetailsLocation: parsedJson['location'],
      searchSuggestedPageDetailsPrecinct: parsedJson['precinct'],
      searchSuggestedPageDetailsDob: parsedJson['dob'],
      searchSuggestedPageDetailsRip: parsedJson['rip'],
      searchSuggestedPageDetailsState: parsedJson['state'],
      searchSuggestedPageDetailsCountry: parsedJson['country'],
    );
  }
}

class APIRegularSearchSuggestedExtendedPageCreator{
  int serachSuggestedPageCreatorId;
  String serachSuggestedPageCreatorFirstName;
  String serachSuggestedPageCreatorLastName;
  String serachSuggestedPageCreatorPhoneNumber;
  String serachSuggestedPageCreatorEmail;
  String serachSuggestedPageCreatorUserName;
  dynamic serachSuggestedPageCreatorImage;

  APIRegularSearchSuggestedExtendedPageCreator({this.serachSuggestedPageCreatorId, this.serachSuggestedPageCreatorFirstName, this.serachSuggestedPageCreatorLastName, this.serachSuggestedPageCreatorPhoneNumber, this.serachSuggestedPageCreatorEmail, this.serachSuggestedPageCreatorUserName, this.serachSuggestedPageCreatorImage});

  factory APIRegularSearchSuggestedExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularSearchSuggestedExtendedPageCreator(
      serachSuggestedPageCreatorId: parsedJson['id'],
      serachSuggestedPageCreatorFirstName: parsedJson['first_name'],
      serachSuggestedPageCreatorLastName: parsedJson['last_name'],
      serachSuggestedPageCreatorPhoneNumber: parsedJson['phone_number'],
      serachSuggestedPageCreatorEmail: parsedJson['email'],
      serachSuggestedPageCreatorUserName: parsedJson['username'],
      serachSuggestedPageCreatorImage: parsedJson['image']
    );
  }
}