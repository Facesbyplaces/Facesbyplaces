import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMHomeTabMemorialMain> apiBLMHomeMemorialsTab({int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/mainpages/memorials?page=$page',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMHomeTabMemorialMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the memorials');
  }
}

class APIBLMHomeTabMemorialMain{

  APIBLMHomeTabMemorialExtended blmFamilyMemorialList;
  APIBLMHomeTabMemorialExtended blmFriendsMemorialList;

  APIBLMHomeTabMemorialMain({this.blmFamilyMemorialList, this.blmFriendsMemorialList});

  factory APIBLMHomeTabMemorialMain.fromJson(Map<String, dynamic> parsedJson){

    return APIBLMHomeTabMemorialMain(
      blmFamilyMemorialList: APIBLMHomeTabMemorialExtended.fromJson(parsedJson['family']),
      blmFriendsMemorialList: APIBLMHomeTabMemorialExtended.fromJson(parsedJson['friends']),
    );
  }
}

class APIBLMHomeTabMemorialExtended{
  int blmHomeTabMemorialFamilyItemsRemaining;
  int memorialHomeTabMemorialFamilyItemsRemaining;
  int blmHomeTabMemorialFriendsItemsRemaining;
  int memorialHomeTabMemorialFriendsItemsRemaining;
  List<APIBLMHomeTabMemorialExtendedPage> blmHomeTabMemorialPage;
  List<APIBLMHomeTabMemorialExtendedPage> memorialHomeTabMemorialPage;

  APIBLMHomeTabMemorialExtended({this.blmHomeTabMemorialPage, this.memorialHomeTabMemorialPage, this.blmHomeTabMemorialFamilyItemsRemaining, this.memorialHomeTabMemorialFamilyItemsRemaining, this.blmHomeTabMemorialFriendsItemsRemaining, this.memorialHomeTabMemorialFriendsItemsRemaining});

  factory APIBLMHomeTabMemorialExtended.fromJson(Map<String, dynamic> parsedJson){

    var blmList = parsedJson['blm'] as List;
    var memorialList = parsedJson['memorial'] as List;

    List<APIBLMHomeTabMemorialExtendedPage> newBLMList = blmList.map((e) => APIBLMHomeTabMemorialExtendedPage.fromJson(e)).toList();
    List<APIBLMHomeTabMemorialExtendedPage> newMemorialList = memorialList.map((e) => APIBLMHomeTabMemorialExtendedPage.fromJson(e)).toList();

    return APIBLMHomeTabMemorialExtended(
      blmHomeTabMemorialPage: newBLMList,
      memorialHomeTabMemorialPage: newMemorialList,
      blmHomeTabMemorialFamilyItemsRemaining: parsedJson['blmFamilyItemsRemaining'],
      memorialHomeTabMemorialFamilyItemsRemaining: parsedJson['memorialFamilyItemsRemaining'],
      blmHomeTabMemorialFriendsItemsRemaining: parsedJson['blmFriendsItemsRemaining'],
      memorialHomeTabMemorialFriendsItemsRemaining: parsedJson['memorialFriendsItemsRemaining']
    );
  }
}

class APIBLMHomeTabMemorialExtendedPage{
  int blmHomeTabMemorialPageId;
  String blmHomeTabMemorialPageName;
  APIBLMHomeTabMemorialExtendedPageDetails blmHomeTabMemorialPageDetails;
  dynamic blmHomeTabMemorialPageBackgroundImage;
  dynamic blmHomeTabMemorialPageProfileImage;
  dynamic blmHomeTabMemorialPageImagesOrVideos;
  String blmHomeTabMemorialPageRelationship;
  APIBLMHomeTabMemorialExtendedPageCreator blmHomeTabMemorialPagePageCreator;
  bool blmHomeTabMemorialPageManage;
  bool blmHomeTabMemorialPageFamOrFriends;
  bool blmHomeTabMemorialPageFollower;
  String blmHomeTabMemorialPagePageType;
  String blmHomeTabMemorialPagePrivacy;

  APIBLMHomeTabMemorialExtendedPage({this.blmHomeTabMemorialPageId, this.blmHomeTabMemorialPageName, this.blmHomeTabMemorialPageDetails, this.blmHomeTabMemorialPageBackgroundImage, this.blmHomeTabMemorialPageProfileImage, this.blmHomeTabMemorialPageImagesOrVideos, this.blmHomeTabMemorialPageRelationship, this.blmHomeTabMemorialPagePageCreator, this.blmHomeTabMemorialPageManage, this.blmHomeTabMemorialPageFamOrFriends, this.blmHomeTabMemorialPageFollower, this.blmHomeTabMemorialPagePageType, this.blmHomeTabMemorialPagePrivacy});

  factory APIBLMHomeTabMemorialExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeTabMemorialExtendedPage(
      blmHomeTabMemorialPageId: parsedJson['id'],
      blmHomeTabMemorialPageName: parsedJson['name'],
      blmHomeTabMemorialPageDetails: APIBLMHomeTabMemorialExtendedPageDetails.fromJson(parsedJson['details']),
      blmHomeTabMemorialPageBackgroundImage: parsedJson['backgroundImage'],
      blmHomeTabMemorialPageProfileImage: parsedJson['profileImage'],
      blmHomeTabMemorialPageImagesOrVideos: parsedJson['imagesOrVideos'],
      blmHomeTabMemorialPageRelationship: parsedJson['relationship'],
      blmHomeTabMemorialPagePageCreator: APIBLMHomeTabMemorialExtendedPageCreator.fromJson(parsedJson['page_creator']),
      blmHomeTabMemorialPageManage: parsedJson['manage'],
      blmHomeTabMemorialPageFamOrFriends: parsedJson['famOrFriends'],
      blmHomeTabMemorialPageFollower: parsedJson['follower'],
      blmHomeTabMemorialPagePageType: parsedJson['page_type'],
      blmHomeTabMemorialPagePrivacy: parsedJson['privacy'],
    );
  }
}

class APIBLMHomeTabMemorialExtendedPageDetails{
  String blmHomeTabMemorialPageDetailsDescription;
  String blmHomeTabMemorialPageDetailsBirthPlace;
  String blmHomeTabMemorialPageDetailsDob;
  String blmHomeTabMemorialPageDetailsRip;
  String blmHomeTabMemorialPageDetailsCemetery;
  String blmHomeTabMemorialPageDetailsCountry;

  APIBLMHomeTabMemorialExtendedPageDetails({this.blmHomeTabMemorialPageDetailsDescription, this.blmHomeTabMemorialPageDetailsBirthPlace, this.blmHomeTabMemorialPageDetailsDob, this.blmHomeTabMemorialPageDetailsRip, this.blmHomeTabMemorialPageDetailsCemetery, this.blmHomeTabMemorialPageDetailsCountry});

  factory APIBLMHomeTabMemorialExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeTabMemorialExtendedPageDetails(
      blmHomeTabMemorialPageDetailsDescription: parsedJson['description'],
      blmHomeTabMemorialPageDetailsBirthPlace: parsedJson['birthplace'],
      blmHomeTabMemorialPageDetailsDob: parsedJson['dob'],
      blmHomeTabMemorialPageDetailsRip: parsedJson['rip'],
      blmHomeTabMemorialPageDetailsCemetery: parsedJson['cemetery'],
      blmHomeTabMemorialPageDetailsCountry: parsedJson['country'],
    );
  }
}

class APIBLMHomeTabMemorialExtendedPageCreator{
  int blmHomeTabMemorialPageCreatorId;
  String blmHomeTabMemorialPageCreatorFirstName;
  String blmHomeTabMemorialPageCreatorLastName;
  String blmHomeTabMemorialPageCreatorPhoneNumber;
  String blmHomeTabMemorialPageCreatorEmail;
  String blmHomeTabMemorialPageCreatorUserName;
  dynamic blmHomeTabMemorialPageCreatorImage;

  APIBLMHomeTabMemorialExtendedPageCreator({this.blmHomeTabMemorialPageCreatorId, this.blmHomeTabMemorialPageCreatorFirstName, this.blmHomeTabMemorialPageCreatorLastName, this.blmHomeTabMemorialPageCreatorPhoneNumber, this.blmHomeTabMemorialPageCreatorEmail, this.blmHomeTabMemorialPageCreatorUserName, this.blmHomeTabMemorialPageCreatorImage});

  factory APIBLMHomeTabMemorialExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeTabMemorialExtendedPageCreator(
      blmHomeTabMemorialPageCreatorId: parsedJson['id'],
      blmHomeTabMemorialPageCreatorFirstName: parsedJson['first_name'],
      blmHomeTabMemorialPageCreatorLastName: parsedJson['last_name'],
      blmHomeTabMemorialPageCreatorPhoneNumber: parsedJson['phone_number'],
      blmHomeTabMemorialPageCreatorEmail: parsedJson['email'],
      blmHomeTabMemorialPageCreatorUserName: parsedJson['username'],
      blmHomeTabMemorialPageCreatorImage: parsedJson['image']
    );
  }
}
