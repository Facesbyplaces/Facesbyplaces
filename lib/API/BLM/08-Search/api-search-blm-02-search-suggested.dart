import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMSearchSuggestedMain> apiBLMSearchSuggested({int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/search/suggested/?page=$page',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The status code of suggested in blm is ${response.statusCode}');
  print('The status body of suggested in blm is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMSearchSuggestedMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the feed');
  }
}

class APIBLMSearchSuggestedMain{
  int blmItemsRemaining;
  List<APIBLMSearchSuggestedExtended> blmPages;

  APIBLMSearchSuggestedMain({this.blmItemsRemaining, this.blmPages});

  factory APIBLMSearchSuggestedMain.fromJson(Map<String, dynamic> parsedJson){

    var newList = parsedJson['pages'] as List;
    List<APIBLMSearchSuggestedExtended> pagesList = newList.map((i) => APIBLMSearchSuggestedExtended.fromJson(i)).toList();

    return APIBLMSearchSuggestedMain(
      blmItemsRemaining: parsedJson['itemsRemaining'],
      blmPages: pagesList,
    );
  }
}

class APIBLMSearchSuggestedExtended{
  int searchSuggestedId;
  APIBLMSearchSuggestedExtendedPage searchSuggestedPage;

  APIBLMSearchSuggestedExtended({this.searchSuggestedId, this.searchSuggestedPage});

  factory APIBLMSearchSuggestedExtended.fromJson(Map<String, dynamic> parsedJson){
    
    return APIBLMSearchSuggestedExtended(
      searchSuggestedId: parsedJson['id'],
      searchSuggestedPage: APIBLMSearchSuggestedExtendedPage.fromJson(parsedJson['page'])
    );
  }
}

class APIBLMSearchSuggestedExtendedPage{
  int searchSuggestedPageId;
  String searchSuggestedPageName;
  APIBLMSearchSuggestedPageDetails searchSuggestedPageDetails;
  dynamic searchSuggestedPageBackgroundImage;
  dynamic searchSuggestedPageProfileImage;
  dynamic searchSuggestedPageImagesOrVideos;
  String searchSuggestedPageRelationship;
  APIBLMSearchSuggestedExtendedPageCreator searchSuggestedPagePageCreator;
  bool searchSuggestedPageManage;
  bool searchSuggestedPageFamOrFriends;
  bool searchSuggestedPageFollower;
  String searchSuggestedPagePageType;
  String searchSuggestedPagePrivacy;

  APIBLMSearchSuggestedExtendedPage({this.searchSuggestedPageId, this.searchSuggestedPageName, this.searchSuggestedPageDetails, this.searchSuggestedPageBackgroundImage, this.searchSuggestedPageProfileImage, this.searchSuggestedPageImagesOrVideos, this.searchSuggestedPageRelationship, this.searchSuggestedPagePageCreator, this.searchSuggestedPageManage, this.searchSuggestedPageFamOrFriends, this.searchSuggestedPageFollower, this.searchSuggestedPagePageType, this.searchSuggestedPagePrivacy});

  factory APIBLMSearchSuggestedExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMSearchSuggestedExtendedPage(
      searchSuggestedPageId: parsedJson['id'],
      searchSuggestedPageName: parsedJson['name'],
      searchSuggestedPageDetails: APIBLMSearchSuggestedPageDetails.fromJson(parsedJson['details']),
      searchSuggestedPageBackgroundImage: parsedJson['backgroundImage'],
      searchSuggestedPageProfileImage: parsedJson['profileImage'],
      searchSuggestedPageImagesOrVideos: parsedJson['imagesOrVideos'],
      searchSuggestedPageRelationship: parsedJson['relationship'],
      searchSuggestedPagePageCreator: APIBLMSearchSuggestedExtendedPageCreator.fromJson(parsedJson['page_creator']),
      searchSuggestedPageManage: parsedJson['manage'],
      searchSuggestedPageFamOrFriends: parsedJson['famOrFriends'],
      searchSuggestedPageFollower: parsedJson['follower'],
      searchSuggestedPagePageType: parsedJson['page_type'],
      searchSuggestedPagePrivacy: parsedJson['privacy'],
    );
  }
}

class APIBLMSearchSuggestedPageDetails{
  String searchSuggestedPageDetailsDescription;
  String searchSuggestedPageDetailsLocation;
  String searchSuggestedPageDetailsPrecinct;
  String searchSuggestedPageDetailsDob;
  String searchSuggestedPageDetailsRip;
  String searchSuggestedPageDetailsState;
  String searchSuggestedPageDetailsCountry;

  APIBLMSearchSuggestedPageDetails({this.searchSuggestedPageDetailsDescription, this.searchSuggestedPageDetailsLocation, this.searchSuggestedPageDetailsPrecinct, this.searchSuggestedPageDetailsDob, this.searchSuggestedPageDetailsRip, this.searchSuggestedPageDetailsState, this.searchSuggestedPageDetailsCountry});

  factory APIBLMSearchSuggestedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMSearchSuggestedPageDetails(
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

class APIBLMSearchSuggestedExtendedPageCreator{
  int searchSuggestedPageCreatorId;
  String searchSuggestedPageCreatorFirstName;
  String searchSuggestedPageCreatorLastName;
  String searchSuggestedPageCreatorPhoneNumber;
  String searchSuggestedPageCreatorEmail;
  String searchSuggestedPageCreatorUserName;
  dynamic searchSuggestedPageCreatorImage;

  APIBLMSearchSuggestedExtendedPageCreator({this.searchSuggestedPageCreatorId, this.searchSuggestedPageCreatorFirstName, this.searchSuggestedPageCreatorLastName, this.searchSuggestedPageCreatorPhoneNumber, this.searchSuggestedPageCreatorEmail, this.searchSuggestedPageCreatorUserName, this.searchSuggestedPageCreatorImage});

  factory APIBLMSearchSuggestedExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMSearchSuggestedExtendedPageCreator(
      searchSuggestedPageCreatorId: parsedJson['id'],
      searchSuggestedPageCreatorFirstName: parsedJson['first_name'],
      searchSuggestedPageCreatorLastName: parsedJson['last_name'],
      searchSuggestedPageCreatorPhoneNumber: parsedJson['phone_number'],
      searchSuggestedPageCreatorEmail: parsedJson['email'],
      searchSuggestedPageCreatorUserName: parsedJson['username'],
      searchSuggestedPageCreatorImage: parsedJson['image']
    );
  }
}