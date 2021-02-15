import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMSearchNearbyMain> apiBLMSearchNearby({int page, double latitude, double longitude}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/search/nearby?longitude=$longitude&latitude=$latitude&page=$page',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMSearchNearbyMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the feed');
  }
}

class APIBLMSearchNearbyMain{
  int blmItemsRemaining;
  int memorialItemsRemaining;
  List<APIBLMSearchNearbyExtended> blmList;
  List<APIBLMSearchNearbyExtended> memorialList;

  APIBLMSearchNearbyMain({this.blmItemsRemaining, this.memorialItemsRemaining, this.blmList, this.memorialList});

  factory APIBLMSearchNearbyMain.fromJson(Map<String, dynamic> parsedJson){
    var newList1 = parsedJson['blm'] as List;
    var newList2 = parsedJson['memorial'] as List;

    List<APIBLMSearchNearbyExtended> blmList = newList1.map((i) => APIBLMSearchNearbyExtended.fromJson(i)).toList();
    List<APIBLMSearchNearbyExtended> memorialList = newList2.map((e) => APIBLMSearchNearbyExtended.fromJson(e)).toList();

    return APIBLMSearchNearbyMain(
      blmItemsRemaining: parsedJson['blmItemsRemaining'],
      memorialItemsRemaining: parsedJson['memorialItemsRemaining'],
      blmList: blmList,
      memorialList: memorialList,
    );
  }
}

class APIBLMSearchNearbyExtended{
  int searchNearbyId;
  String searchNearbyName;
  APIBLMSearchNearbyExtendedPageDetails searchNearbyDetails;
  dynamic searchNearbyBackgroundImage;
  dynamic searchNearbyProfileImage;
  dynamic searchNearbyImagesOrVideos;
  String searchNearbyRelationship;
  APIBLMSearchNearbyExtendedPageCreator searchNearbyPageCreator;
  bool searchNearbyManage;
  bool searchNearbyFamOrFriends;
  bool searchNearbyFollower;
  String searchNearbyPageType;
  String searchNearbyPrivacy;

  APIBLMSearchNearbyExtended({this.searchNearbyId, this.searchNearbyName, this.searchNearbyDetails, this.searchNearbyBackgroundImage, this.searchNearbyProfileImage, this.searchNearbyImagesOrVideos, this.searchNearbyRelationship, this.searchNearbyPageCreator, this.searchNearbyManage, this.searchNearbyFamOrFriends, this.searchNearbyFollower, this.searchNearbyPageType, this.searchNearbyPrivacy});

  factory APIBLMSearchNearbyExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMSearchNearbyExtended(
      searchNearbyId: parsedJson['id'],
      searchNearbyName: parsedJson['name'],
      searchNearbyDetails: APIBLMSearchNearbyExtendedPageDetails.fromJson(parsedJson['details']),
      searchNearbyBackgroundImage: parsedJson['backgroundImage'],
      searchNearbyProfileImage: parsedJson['profileImage'],
      searchNearbyImagesOrVideos: parsedJson['imagesOrVideos'],
      searchNearbyRelationship: parsedJson['relationship'],
      searchNearbyPageCreator: APIBLMSearchNearbyExtendedPageCreator.fromJson(parsedJson['page_creator']),
      searchNearbyManage: parsedJson['manage'],
      searchNearbyFamOrFriends: parsedJson['famOrFriends'],
      searchNearbyFollower: parsedJson['follower'],
      searchNearbyPageType: parsedJson['page_type'],
      searchNearbyPrivacy: parsedJson['privacy'],
    );
  }
}

class APIBLMSearchNearbyExtendedPageDetails{
  String searchNearbyPageDetailsDescription;
  String searchNearbyPageDetailsLocation;
  String searchNearbyPageDetailsPrecinct;
  String searchNearbyPageDetailsDob;
  String searchNearbyPageDetailsRip;
  String searchNearbyPageDetailsState;
  String searchNearbyPageDetailsCountry;

  APIBLMSearchNearbyExtendedPageDetails({this.searchNearbyPageDetailsDescription, this.searchNearbyPageDetailsLocation, this.searchNearbyPageDetailsPrecinct, this.searchNearbyPageDetailsDob, this.searchNearbyPageDetailsRip, this.searchNearbyPageDetailsState, this.searchNearbyPageDetailsCountry});

  factory APIBLMSearchNearbyExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMSearchNearbyExtendedPageDetails(
      searchNearbyPageDetailsDescription: parsedJson['description'],
      searchNearbyPageDetailsLocation: parsedJson['location'],
      searchNearbyPageDetailsPrecinct: parsedJson['precinct'],
      searchNearbyPageDetailsDob: parsedJson['dob'],
      searchNearbyPageDetailsRip: parsedJson['rip'],
      searchNearbyPageDetailsState: parsedJson['state'],
      searchNearbyPageDetailsCountry: parsedJson['country'],
    );
  }
}

class APIBLMSearchNearbyExtendedPageCreator{
  int searchNearbyPageCreatorId;
  String searchNearbyPageCreatorFirstName;
  String searchNearbyPageCreatorLastName;
  String searchNearbyPageCreatorPhoneNumber;
  String searchNearbyPageCreatorEmail;
  String searchNearbyPageCreatorUserName;
  dynamic searchNearbyPageCreatorImage;

  APIBLMSearchNearbyExtendedPageCreator({this.searchNearbyPageCreatorId, this.searchNearbyPageCreatorFirstName, this.searchNearbyPageCreatorLastName, this.searchNearbyPageCreatorPhoneNumber, this.searchNearbyPageCreatorEmail, this.searchNearbyPageCreatorUserName, this.searchNearbyPageCreatorImage});

  factory APIBLMSearchNearbyExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMSearchNearbyExtendedPageCreator(
      searchNearbyPageCreatorId: parsedJson['id'],
      searchNearbyPageCreatorFirstName: parsedJson['first_name'],
      searchNearbyPageCreatorLastName: parsedJson['last_name'],
      searchNearbyPageCreatorPhoneNumber: parsedJson['phone_number'],
      searchNearbyPageCreatorEmail: parsedJson['email'],
      searchNearbyPageCreatorUserName: parsedJson['username'],
      searchNearbyPageCreatorImage: parsedJson['image']
    );
  }
}