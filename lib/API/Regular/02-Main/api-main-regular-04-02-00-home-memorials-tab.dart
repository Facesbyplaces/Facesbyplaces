import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularHomeTabMemorialMain> apiRegularHomeMemorialsTab({int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

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
    return APIRegularHomeTabMemorialMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the memorials');
  }
}

class APIRegularHomeTabMemorialMain{

  APIRegularHomeTabMemorialExtended almFamilyMemorialList;
  APIRegularHomeTabMemorialExtended almFriendsMemorialList;

  APIRegularHomeTabMemorialMain({this.almFamilyMemorialList, this.almFriendsMemorialList});

  factory APIRegularHomeTabMemorialMain.fromJson(Map<String, dynamic> parsedJson){

    return APIRegularHomeTabMemorialMain(
      almFamilyMemorialList: APIRegularHomeTabMemorialExtended.fromJson(parsedJson['family']),
      almFriendsMemorialList: APIRegularHomeTabMemorialExtended.fromJson(parsedJson['friends']),
    );
  }
}

class APIRegularHomeTabMemorialExtended{
  int blmHomeTabMemorialFamilyItemsRemaining;
  int memorialHomeTabMemorialFamilyItemsRemaining;
  int blmHomeTabMemorialFriendsItemsRemaining;
  int memorialHomeTabMemorialFriendsItemsRemaining;
  List<APIRegularHomeTabMemorialExtendedPage> blmHomeTabMemorialPage;
  List<APIRegularHomeTabMemorialExtendedPage> memorialHomeTabMemorialPage;

  APIRegularHomeTabMemorialExtended({this.blmHomeTabMemorialPage, this.memorialHomeTabMemorialPage, this.blmHomeTabMemorialFamilyItemsRemaining, this.memorialHomeTabMemorialFamilyItemsRemaining, this.blmHomeTabMemorialFriendsItemsRemaining, this.memorialHomeTabMemorialFriendsItemsRemaining});

  factory APIRegularHomeTabMemorialExtended.fromJson(Map<String, dynamic> parsedJson){

    var blmList = parsedJson['blm'] as List;
    var memorialList = parsedJson['memorial'] as List;

    List<APIRegularHomeTabMemorialExtendedPage> newBLMList = blmList.map((e) => APIRegularHomeTabMemorialExtendedPage.fromJson(e)).toList();
    List<APIRegularHomeTabMemorialExtendedPage> newMemorialList = memorialList.map((e) => APIRegularHomeTabMemorialExtendedPage.fromJson(e)).toList();

    return APIRegularHomeTabMemorialExtended(
      blmHomeTabMemorialPage: newBLMList,
      memorialHomeTabMemorialPage: newMemorialList,
      blmHomeTabMemorialFamilyItemsRemaining: parsedJson['blmFamilyItemsRemaining'],
      memorialHomeTabMemorialFamilyItemsRemaining: parsedJson['memorialFamilyItemsRemaining'],
      blmHomeTabMemorialFriendsItemsRemaining: parsedJson['blmFriendsItemsRemaining'],
      memorialHomeTabMemorialFriendsItemsRemaining: parsedJson['memorialFriendsItemsRemaining']
    );
  }
}

class APIRegularHomeTabMemorialExtendedPage{
  int blmHomeTabMemorialPageId;
  String blmHomeTabMemorialPageName;
  APIRegularHomeTabMemorialExtendedPageDetails blmHomeTabMemorialPageDetails;
  dynamic blmHomeTabMemorialPageBackgroundImage;
  dynamic blmHomeTabMemorialPageProfileImage;
  dynamic blmHomeTabMemorialPageImagesOrVideos;
  String blmHomeTabMemorialPageRelationship;
  APIRegularHomeTabMemorialExtendedPageCreator blmHomeTabMemorialPagePageCreator;
  bool blmHomeTabMemorialPageManage;
  bool blmHomeTabMemorialPageFamOrFriends;
  bool blmHomeTabMemorialPageFollower;
  String blmHomeTabMemorialPagePageType;
  String blmHomeTabMemorialPagePrivacy;

  APIRegularHomeTabMemorialExtendedPage({this.blmHomeTabMemorialPageId, this.blmHomeTabMemorialPageName, this.blmHomeTabMemorialPageDetails, this.blmHomeTabMemorialPageBackgroundImage, this.blmHomeTabMemorialPageProfileImage, this.blmHomeTabMemorialPageImagesOrVideos, this.blmHomeTabMemorialPageRelationship, this.blmHomeTabMemorialPagePageCreator, this.blmHomeTabMemorialPageManage, this.blmHomeTabMemorialPageFamOrFriends, this.blmHomeTabMemorialPageFollower, this.blmHomeTabMemorialPagePageType, this.blmHomeTabMemorialPagePrivacy});

  factory APIRegularHomeTabMemorialExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeTabMemorialExtendedPage(
      blmHomeTabMemorialPageId: parsedJson['id'],
      blmHomeTabMemorialPageName: parsedJson['name'],
      blmHomeTabMemorialPageDetails: APIRegularHomeTabMemorialExtendedPageDetails.fromJson(parsedJson['details']),
      blmHomeTabMemorialPageBackgroundImage: parsedJson['backgroundImage'],
      blmHomeTabMemorialPageProfileImage: parsedJson['profileImage'],
      blmHomeTabMemorialPageImagesOrVideos: parsedJson['imagesOrVideos'],
      blmHomeTabMemorialPageRelationship: parsedJson['relationship'],
      blmHomeTabMemorialPagePageCreator: APIRegularHomeTabMemorialExtendedPageCreator.fromJson(parsedJson['page_creator']),
      blmHomeTabMemorialPageManage: parsedJson['manage'],
      blmHomeTabMemorialPageFamOrFriends: parsedJson['famOrFriends'],
      blmHomeTabMemorialPageFollower: parsedJson['follower'],
      blmHomeTabMemorialPagePageType: parsedJson['page_type'],
      blmHomeTabMemorialPagePrivacy: parsedJson['privacy'],
    );
  }
}

class APIRegularHomeTabMemorialExtendedPageDetails{
  String blmHomeTabMemorialPageDetailsDescription;
  String blmHomeTabMemorialPageDetailsBirthPlace;
  String blmHomeTabMemorialPageDetailsDob;
  String blmHomeTabMemorialPageDetailsRip;
  String blmHomeTabMemorialPageDetailsCemetery;
  String blmHomeTabMemorialPageDetailsCountry;

  APIRegularHomeTabMemorialExtendedPageDetails({this.blmHomeTabMemorialPageDetailsDescription, this.blmHomeTabMemorialPageDetailsBirthPlace, this.blmHomeTabMemorialPageDetailsDob, this.blmHomeTabMemorialPageDetailsRip, this.blmHomeTabMemorialPageDetailsCemetery, this.blmHomeTabMemorialPageDetailsCountry});

  factory APIRegularHomeTabMemorialExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeTabMemorialExtendedPageDetails(
      blmHomeTabMemorialPageDetailsDescription: parsedJson['description'],
      blmHomeTabMemorialPageDetailsBirthPlace: parsedJson['birthplace'],
      blmHomeTabMemorialPageDetailsDob: parsedJson['dob'],
      blmHomeTabMemorialPageDetailsRip: parsedJson['rip'],
      blmHomeTabMemorialPageDetailsCemetery: parsedJson['cemetery'],
      blmHomeTabMemorialPageDetailsCountry: parsedJson['country'],
    );
  }
}

class APIRegularHomeTabMemorialExtendedPageCreator{
  int blmHomeTabMemorialPageCreatorId;
  String blmHomeTabMemorialPageCreatorFirstName;
  String blmHomeTabMemorialPageCreatorLastName;
  String blmHomeTabMemorialPageCreatorPhoneNumber;
  String blmHomeTabMemorialPageCreatorEmail;
  String blmHomeTabMemorialPageCreatorUserName;
  dynamic blmHomeTabMemorialPageCreatorImage;

  APIRegularHomeTabMemorialExtendedPageCreator({this.blmHomeTabMemorialPageCreatorId, this.blmHomeTabMemorialPageCreatorFirstName, this.blmHomeTabMemorialPageCreatorLastName, this.blmHomeTabMemorialPageCreatorPhoneNumber, this.blmHomeTabMemorialPageCreatorEmail, this.blmHomeTabMemorialPageCreatorUserName, this.blmHomeTabMemorialPageCreatorImage});

  factory APIRegularHomeTabMemorialExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeTabMemorialExtendedPageCreator(
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
