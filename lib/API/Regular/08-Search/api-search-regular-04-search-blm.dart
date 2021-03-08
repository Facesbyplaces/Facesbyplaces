import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularSearchBLMMemorialMain> apiRegularSearchBLM({required String keywords, required int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get(
    Uri.http('http://fbp.dev1.koda.ws/api/v1/search/memorials?keywords=$keywords&page=blm&page=$page', ''),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The status code of blm in alm is ${response.statusCode}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularSearchBLMMemorialMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the memorials.');
  }
}

class APIRegularSearchBLMMemorialMain{
  int almItemsRemaining;
  List<APIRegularSearchBLMMemorialExtended> almMemorialList;

  APIRegularSearchBLMMemorialMain({required this.almItemsRemaining, required this.almMemorialList});

  factory APIRegularSearchBLMMemorialMain.fromJson(Map<String, dynamic> parsedJson){

    var memorialList = parsedJson['memorials'] as List;
    List<APIRegularSearchBLMMemorialExtended> newMemorialList = memorialList.map((e) => APIRegularSearchBLMMemorialExtended.fromJson(e)).toList();

    return APIRegularSearchBLMMemorialMain(
      almItemsRemaining: parsedJson['itemsremaining'],
      almMemorialList: newMemorialList,
    );
  }
}

class APIRegularSearchBLMMemorialExtended{
  int searchBLMMemorialId;
  APIRegularSearchBLMMemorialExtendedPage searchBLMMemorialPage;

  APIRegularSearchBLMMemorialExtended({required this.searchBLMMemorialId, required this.searchBLMMemorialPage});

  factory APIRegularSearchBLMMemorialExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularSearchBLMMemorialExtended(
      searchBLMMemorialId: parsedJson['id'],
      searchBLMMemorialPage: APIRegularSearchBLMMemorialExtendedPage.fromJson(parsedJson['page']),
    );
  }
}

class APIRegularSearchBLMMemorialExtendedPage{
  int searchBLMMemorialPageId;
  String searchBLMMemorialPageName;
  APIRegularSearchBLMMemorialExtendedPageDetails searchBLMMemorialPageDetails;
  dynamic searchBLMMemorialPageBackgroundImage;
  dynamic searchBLMMemorialPageProfileImage;
  List<dynamic> searchBLMMemorialPageImagesOrVideos;
  String searchBLMMemorialPageRelationship;
  // APIRegularSearchBLMMemorialExtendedPageCreator searchBLMMemorialPagePageCreator;
  bool searchBLMMemorialPageManage;
  bool searchBLMMemorialPageFamOrFriends;
  bool searchBLMMemorialPageFollower;
  String searchBLMMemorialPagePageType;
  String searchBLMMemorialPagePrivacy;

  APIRegularSearchBLMMemorialExtendedPage({required this.searchBLMMemorialPageId, required this.searchBLMMemorialPageName, required this.searchBLMMemorialPageDetails, required this.searchBLMMemorialPageBackgroundImage, required this.searchBLMMemorialPageProfileImage, required this.searchBLMMemorialPageImagesOrVideos, required this.searchBLMMemorialPageRelationship, required this.searchBLMMemorialPageManage, required this.searchBLMMemorialPageFamOrFriends, required this.searchBLMMemorialPageFollower, required this.searchBLMMemorialPagePageType, required this.searchBLMMemorialPagePrivacy});

  factory APIRegularSearchBLMMemorialExtendedPage.fromJson(Map<String, dynamic> parsedJson){

    List<dynamic>? newList1;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList1 = List<dynamic>.from(list);
    }

    return APIRegularSearchBLMMemorialExtendedPage(
      searchBLMMemorialPageId: parsedJson['id'],
      searchBLMMemorialPageName: parsedJson['name'],
      searchBLMMemorialPageDetails: APIRegularSearchBLMMemorialExtendedPageDetails.fromJson(parsedJson['details']),
      searchBLMMemorialPageBackgroundImage: parsedJson['backgroundImage'],
      searchBLMMemorialPageProfileImage: parsedJson['profileImage'],
      searchBLMMemorialPageImagesOrVideos: newList1!,
      searchBLMMemorialPageRelationship: parsedJson['relationship'],
      // searchBLMMemorialPagePageCreator: APIRegularSearchBLMMemorialExtendedPageCreator.fromJson(parsedJson['page_creator']),
      searchBLMMemorialPageManage: parsedJson['manage'],
      searchBLMMemorialPageFamOrFriends: parsedJson['famOrFriends'],
      searchBLMMemorialPageFollower: parsedJson['follower'],
      searchBLMMemorialPagePageType: parsedJson['page_type'],
      searchBLMMemorialPagePrivacy: parsedJson['privacy'],
    );
  }
}

class APIRegularSearchBLMMemorialExtendedPageDetails{
  String searchBLMMemorialPageDetailsDescription;
  String searchBLMMemorialPageDetailsBirthPlace;
  String searchBLMMemorialPageDetailsDob;
  String searchBLMMemorialPageDetailsRip;
  String searchBLMMemorialPageDetailsCemetery;
  String searchBLMMemorialPageDetailsCountry;

  APIRegularSearchBLMMemorialExtendedPageDetails({required this.searchBLMMemorialPageDetailsDescription, required this.searchBLMMemorialPageDetailsBirthPlace, required this.searchBLMMemorialPageDetailsDob, required this.searchBLMMemorialPageDetailsRip, required this.searchBLMMemorialPageDetailsCemetery, required this.searchBLMMemorialPageDetailsCountry});

  factory APIRegularSearchBLMMemorialExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularSearchBLMMemorialExtendedPageDetails(
      searchBLMMemorialPageDetailsDescription: parsedJson['description'],
      searchBLMMemorialPageDetailsBirthPlace: parsedJson['birthplace'],
      searchBLMMemorialPageDetailsDob: parsedJson['dob'],
      searchBLMMemorialPageDetailsRip: parsedJson['rip'],
      searchBLMMemorialPageDetailsCemetery: parsedJson['cemetery'],
      searchBLMMemorialPageDetailsCountry: parsedJson['country'],
    );
  }
}

class APIRegularSearchBLMMemorialExtendedPageCreator{
  int searchBLMMemorialPageCreatorId;
  String searchBLMMemorialPageCreatorFirstName;
  String searchBLMMemorialPageCreatorLastName;
  String searchBLMMemorialPageCreatorPhoneNumber;
  String searchBLMMemorialPageCreatorEmail;
  String searchBLMMemorialPageCreatorUserName;
  dynamic searchBLMMemorialPageCreatorImage;

  APIRegularSearchBLMMemorialExtendedPageCreator({required this.searchBLMMemorialPageCreatorId, required this.searchBLMMemorialPageCreatorFirstName, required this.searchBLMMemorialPageCreatorLastName, required this.searchBLMMemorialPageCreatorPhoneNumber, required this.searchBLMMemorialPageCreatorEmail, required this.searchBLMMemorialPageCreatorUserName, required this.searchBLMMemorialPageCreatorImage});

  factory APIRegularSearchBLMMemorialExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularSearchBLMMemorialExtendedPageCreator(
      searchBLMMemorialPageCreatorId: parsedJson['id'],
      searchBLMMemorialPageCreatorFirstName: parsedJson['first_name'],
      searchBLMMemorialPageCreatorLastName: parsedJson['last_name'],
      searchBLMMemorialPageCreatorPhoneNumber: parsedJson['phone_number'],
      searchBLMMemorialPageCreatorEmail: parsedJson['email'],
      searchBLMMemorialPageCreatorUserName: parsedJson['username'],
      searchBLMMemorialPageCreatorImage: parsedJson['image']
    );
  }
}
