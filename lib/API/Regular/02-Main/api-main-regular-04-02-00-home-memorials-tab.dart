import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularHomeTabMemorialMain> apiRegularHomeMemorialsTab({required int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get(
    Uri.http('http://fbp.dev1.koda.ws/api/v1/mainpages/memorials?page=$page', ''),
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

  APIRegularHomeTabMemorialMain({required this.almFamilyMemorialList, required this.almFriendsMemorialList});

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

  APIRegularHomeTabMemorialExtended({required this.blmHomeTabMemorialPage, required this.memorialHomeTabMemorialPage, required this.blmHomeTabMemorialFamilyItemsRemaining, required this.memorialHomeTabMemorialFamilyItemsRemaining, required this.blmHomeTabMemorialFriendsItemsRemaining, required this.memorialHomeTabMemorialFriendsItemsRemaining});

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

  APIRegularHomeTabMemorialExtendedPage({required this.blmHomeTabMemorialPageId, required this.blmHomeTabMemorialPageName, required this.blmHomeTabMemorialPageDetails, required this.blmHomeTabMemorialPageBackgroundImage, required this.blmHomeTabMemorialPageProfileImage, required this.blmHomeTabMemorialPageImagesOrVideos, required this.blmHomeTabMemorialPageRelationship, required this.blmHomeTabMemorialPagePageCreator, required this.blmHomeTabMemorialPageManage, required this.blmHomeTabMemorialPageFamOrFriends, required this.blmHomeTabMemorialPageFollower, required this.blmHomeTabMemorialPagePageType, required this.blmHomeTabMemorialPagePrivacy});

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

  APIRegularHomeTabMemorialExtendedPageDetails({required this.blmHomeTabMemorialPageDetailsDescription, required this.blmHomeTabMemorialPageDetailsBirthPlace, required this.blmHomeTabMemorialPageDetailsDob, required this.blmHomeTabMemorialPageDetailsRip, required this.blmHomeTabMemorialPageDetailsCemetery, required this.blmHomeTabMemorialPageDetailsCountry});

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

  APIRegularHomeTabMemorialExtendedPageCreator({required this.blmHomeTabMemorialPageCreatorId, required this.blmHomeTabMemorialPageCreatorFirstName, required this.blmHomeTabMemorialPageCreatorLastName, required this.blmHomeTabMemorialPageCreatorPhoneNumber, required this.blmHomeTabMemorialPageCreatorEmail, required this.blmHomeTabMemorialPageCreatorUserName, required this.blmHomeTabMemorialPageCreatorImage});

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
