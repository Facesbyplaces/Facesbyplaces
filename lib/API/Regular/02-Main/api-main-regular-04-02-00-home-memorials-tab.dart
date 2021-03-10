import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularHomeTabMemorialMain> apiRegularHomeMemorialsTab({required int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get(
    Uri.http('fbp.dev1.koda.ws', '/api/v1/mainpages/memorials', {'page' : '$page',}),
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

  APIRegularHomeTabMemorialFamilyExtended almFamilyMemorialList;
  APIRegularHomeTabMemorialFriendsExtended almFriendsMemorialList;

  APIRegularHomeTabMemorialMain({required this.almFamilyMemorialList, required this.almFriendsMemorialList});

  factory APIRegularHomeTabMemorialMain.fromJson(Map<String, dynamic> parsedJson){

    return APIRegularHomeTabMemorialMain(
      almFamilyMemorialList: APIRegularHomeTabMemorialFamilyExtended.fromJson(parsedJson['family']),
      almFriendsMemorialList: APIRegularHomeTabMemorialFriendsExtended.fromJson(parsedJson['friends']),
    );
  }
}

class APIRegularHomeTabMemorialFamilyExtended{
  int blmHomeTabMemorialFamilyItemsRemaining;
  int memorialHomeTabMemorialFamilyItemsRemaining;
  List<APIRegularHomeTabMemorialExtendedPage> blmHomeTabMemorialPage;
  List<APIRegularHomeTabMemorialExtendedPage> memorialHomeTabMemorialPage;

  APIRegularHomeTabMemorialFamilyExtended({required this.blmHomeTabMemorialPage, required this.memorialHomeTabMemorialPage, required this.blmHomeTabMemorialFamilyItemsRemaining, required this.memorialHomeTabMemorialFamilyItemsRemaining});

  factory APIRegularHomeTabMemorialFamilyExtended.fromJson(Map<String, dynamic> parsedJson){

    var blmList = parsedJson['blm'] as List;
    var memorialList = parsedJson['memorial'] as List;

    List<APIRegularHomeTabMemorialExtendedPage>? newBLMList;
    List<APIRegularHomeTabMemorialExtendedPage>? newMemorialList;

    if(blmList.isNotEmpty == true){
       newBLMList = blmList.map((e) => APIRegularHomeTabMemorialExtendedPage.fromJson(e)).toList();
    }else{
      newBLMList = [];
    }
    
    if(memorialList.isNotEmpty == true){
      newMemorialList = memorialList.map((e) => APIRegularHomeTabMemorialExtendedPage.fromJson(e)).toList();
    }else{
      newMemorialList = [];
    }

    return APIRegularHomeTabMemorialFamilyExtended(
      blmHomeTabMemorialPage: newBLMList,
      memorialHomeTabMemorialPage: newMemorialList,
      blmHomeTabMemorialFamilyItemsRemaining: parsedJson['blmFamilyItemsRemaining'],
      memorialHomeTabMemorialFamilyItemsRemaining: parsedJson['memorialFamilyItemsRemaining'],
    );
  }
}

class APIRegularHomeTabMemorialFriendsExtended{
  int blmHomeTabMemorialFriendsItemsRemaining;
  int memorialHomeTabMemorialFriendsItemsRemaining;
  List<APIRegularHomeTabMemorialExtendedPage> blmHomeTabMemorialPage;
  List<APIRegularHomeTabMemorialExtendedPage> memorialHomeTabMemorialPage;

  APIRegularHomeTabMemorialFriendsExtended({required this.blmHomeTabMemorialPage, required this.memorialHomeTabMemorialPage, required this.blmHomeTabMemorialFriendsItemsRemaining, required this.memorialHomeTabMemorialFriendsItemsRemaining});

  factory APIRegularHomeTabMemorialFriendsExtended.fromJson(Map<String, dynamic> parsedJson){

    var blmList = parsedJson['blm'] as List;
    var memorialList = parsedJson['memorial'] as List;

    List<APIRegularHomeTabMemorialExtendedPage>? newBLMList;
    List<APIRegularHomeTabMemorialExtendedPage>? newMemorialList;

    if(blmList.isNotEmpty == true){
       newBLMList = blmList.map((e) => APIRegularHomeTabMemorialExtendedPage.fromJson(e)).toList();
    }else{
      newBLMList = [];
    }
    
    if(memorialList.isNotEmpty == true){
      newMemorialList = memorialList.map((e) => APIRegularHomeTabMemorialExtendedPage.fromJson(e)).toList();
    }else{
      newMemorialList = [];
    }

    return APIRegularHomeTabMemorialFriendsExtended(
      blmHomeTabMemorialPage: newBLMList,
      memorialHomeTabMemorialPage: newMemorialList,
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
    // print('The value of image is ${parsedJson['profileImage']}');

    return APIRegularHomeTabMemorialExtendedPage(
      blmHomeTabMemorialPageId: parsedJson['id'],
      blmHomeTabMemorialPageName: parsedJson['name'] != null ? parsedJson['name'] : '',
      blmHomeTabMemorialPageDetails: APIRegularHomeTabMemorialExtendedPageDetails.fromJson(parsedJson['details']),
      blmHomeTabMemorialPageBackgroundImage: parsedJson['backgroundImage'] != null ? parsedJson['backgroundImage'] : '',
      blmHomeTabMemorialPageProfileImage: parsedJson['profileImage'] != null ? parsedJson['profileImage'] : '',
      // blmHomeTabMemorialPageProfileImage: 'http://fbp.dev1.koda.ws/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBZjA9IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--b34473e99ff3df7a43c0783acacff451e7a01790/300_2.jpg',
      blmHomeTabMemorialPageImagesOrVideos: parsedJson['imagesOrVideos'],
      blmHomeTabMemorialPageRelationship: parsedJson['relationship'] != null ? parsedJson['relationship'] : '',
      blmHomeTabMemorialPagePageCreator: APIRegularHomeTabMemorialExtendedPageCreator.fromJson(parsedJson['page_creator']),
      blmHomeTabMemorialPageManage: parsedJson['manage'],
      blmHomeTabMemorialPageFamOrFriends: parsedJson['famOrFriends'],
      blmHomeTabMemorialPageFollower: parsedJson['follower'],
      blmHomeTabMemorialPagePageType: parsedJson['page_type'] != null ? parsedJson['page_type'] : '',
      blmHomeTabMemorialPagePrivacy: parsedJson['privacy'] != null ? parsedJson['privacy'] : '',
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
      blmHomeTabMemorialPageDetailsDescription: parsedJson['description'] != null ? parsedJson['description'] : '',
      blmHomeTabMemorialPageDetailsBirthPlace: parsedJson['birthplace'] != null ? parsedJson['birthplace'] : '',
      blmHomeTabMemorialPageDetailsDob: parsedJson['dob'] != null ? parsedJson['dob'] : '',
      blmHomeTabMemorialPageDetailsRip: parsedJson['rip'] != null ? parsedJson['rip'] : '',
      blmHomeTabMemorialPageDetailsCemetery: parsedJson['cemetery'] != null ? parsedJson['cemetery'] : '',
      blmHomeTabMemorialPageDetailsCountry: parsedJson['country'] != null ? parsedJson['country'] : '',
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
  String blmHomeTabMemorialPageCreatorImage;

  APIRegularHomeTabMemorialExtendedPageCreator({required this.blmHomeTabMemorialPageCreatorId, required this.blmHomeTabMemorialPageCreatorFirstName, required this.blmHomeTabMemorialPageCreatorLastName, required this.blmHomeTabMemorialPageCreatorPhoneNumber, required this.blmHomeTabMemorialPageCreatorEmail, required this.blmHomeTabMemorialPageCreatorUserName, required this.blmHomeTabMemorialPageCreatorImage});

  factory APIRegularHomeTabMemorialExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeTabMemorialExtendedPageCreator(
      blmHomeTabMemorialPageCreatorId: parsedJson['id'],
      blmHomeTabMemorialPageCreatorFirstName: parsedJson['first_name'] != null ? parsedJson['first_name'] : '',
      blmHomeTabMemorialPageCreatorLastName: parsedJson['last_name'] != null ? parsedJson['last_name'] : '',
      blmHomeTabMemorialPageCreatorPhoneNumber: parsedJson['phone_number'] != null ? parsedJson['phone_number'] : '',
      blmHomeTabMemorialPageCreatorEmail: parsedJson['email'] != null ? parsedJson['email'] : '',
      blmHomeTabMemorialPageCreatorUserName: parsedJson['username'] != null ? parsedJson['username'] : '',
      blmHomeTabMemorialPageCreatorImage: parsedJson['image'] != null ? parsedJson['image'] : ''
    );
  }
}
