import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularSearchNearbyMain> apiRegularSearchNearby({int page, double latitude, double longitude}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/search/nearby?longitude=$longitude&latitude=$latitude&page=$page',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The status code of nearby in alm is ${response.statusCode}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularSearchNearbyMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the feed');
  }
}

class APIRegularSearchNearbyMain{
  int blmItemsRemaining;
  int memorialItemsRemaining;
  List<APIRegularSearchNearbyExtended> blmList;
  List<APIRegularSearchNearbyExtended> memorialList;

  APIRegularSearchNearbyMain({this.blmItemsRemaining, this.memorialItemsRemaining, this.blmList, this.memorialList});

  factory APIRegularSearchNearbyMain.fromJson(Map<String, dynamic> parsedJson){
    var newList1 = parsedJson['blm'] as List;
    var newList2 = parsedJson['memorial'] as List;

    List<APIRegularSearchNearbyExtended> blmList = newList1.map((i) => APIRegularSearchNearbyExtended.fromJson(i)).toList();
    List<APIRegularSearchNearbyExtended> memorialList = newList2.map((e) => APIRegularSearchNearbyExtended.fromJson(e)).toList();

    return APIRegularSearchNearbyMain(
      blmItemsRemaining: parsedJson['blmItemsRemaining'],
      memorialItemsRemaining: parsedJson['memorialItemsRemaining'],
      blmList: blmList,
      memorialList: memorialList,
    );
  }
}

class APIRegularSearchNearbyExtended{
  int searchNearbyId;
  String searchNearbyName;
  APIRegularSearchNearbyExtendedPageDetails searchNearbyDetails;
  dynamic searchNearbyBackgroundImage;
  dynamic searchNearbyProfileImage;
  dynamic searchNearbyImagesOrVideos;
  String searchNearbyRelationship;
  APIRegularSearchNearbyExtendedPageCreator searchNearbyPageCreator;
  bool searchNearbyManage;
  bool searchNearbyFamOrFriends;
  bool searchNearbyFollower;
  String searchNearbyPageType;
  String searchNearbyPrivacy;

  APIRegularSearchNearbyExtended({this.searchNearbyId, this.searchNearbyName, this.searchNearbyDetails, this.searchNearbyBackgroundImage, this.searchNearbyProfileImage, this.searchNearbyImagesOrVideos, this.searchNearbyRelationship, this.searchNearbyPageCreator, this.searchNearbyManage, this.searchNearbyFamOrFriends, this.searchNearbyFollower, this.searchNearbyPageType, this.searchNearbyPrivacy});

  factory APIRegularSearchNearbyExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularSearchNearbyExtended(
      searchNearbyId: parsedJson['id'],
      searchNearbyName: parsedJson['name'],
      searchNearbyDetails: APIRegularSearchNearbyExtendedPageDetails.fromJson(parsedJson['details']),
      searchNearbyBackgroundImage: parsedJson['backgroundImage'],
      searchNearbyProfileImage: parsedJson['profileImage'],
      searchNearbyImagesOrVideos: parsedJson['imagesOrVideos'],
      searchNearbyRelationship: parsedJson['relationship'],
      // serachNearbyPageCreator: APIRegularSearchNearbyExtendedPageCreator.fromJson(parsedJson['page_creator']),
      searchNearbyManage: parsedJson['manage'],
      searchNearbyFamOrFriends: parsedJson['famOrFriends'],
      searchNearbyFollower: parsedJson['follower'],
      searchNearbyPageType: parsedJson['page_type'],
      searchNearbyPrivacy: parsedJson['privacy'],
    );
  }
}

class APIRegularSearchNearbyExtendedPageDetails{
  String searchNearbyPageDetailsDescription;
  String searchNearbyPageDetailsLocation;
  String searchNearbyPageDetailsPrecinct;
  String searchNearbyPageDetailsDob;
  String searchNearbyPageDetailsRip;
  String searchNearbyPageDetailsState;
  String searchNearbyPageDetailsCountry;

  APIRegularSearchNearbyExtendedPageDetails({this.searchNearbyPageDetailsDescription, this.searchNearbyPageDetailsLocation, this.searchNearbyPageDetailsPrecinct, this.searchNearbyPageDetailsDob, this.searchNearbyPageDetailsRip, this.searchNearbyPageDetailsState, this.searchNearbyPageDetailsCountry});

  factory APIRegularSearchNearbyExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularSearchNearbyExtendedPageDetails(
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

class APIRegularSearchNearbyExtendedPageCreator{
  int serachNearbyPageCreatorId;
  String serachNearbyPageCreatorFirstName;
  String serachNearbyPageCreatorLastName;
  String serachNearbyPageCreatorPhoneNumber;
  String serachNearbyPageCreatorEmail;
  String serachNearbyPageCreatorUserName;
  dynamic serachNearbyPageCreatorImage;

  APIRegularSearchNearbyExtendedPageCreator({this.serachNearbyPageCreatorId, this.serachNearbyPageCreatorFirstName, this.serachNearbyPageCreatorLastName, this.serachNearbyPageCreatorPhoneNumber, this.serachNearbyPageCreatorEmail, this.serachNearbyPageCreatorUserName, this.serachNearbyPageCreatorImage});

  factory APIRegularSearchNearbyExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularSearchNearbyExtendedPageCreator(
      serachNearbyPageCreatorId: parsedJson['id'],
      serachNearbyPageCreatorFirstName: parsedJson['first_name'],
      serachNearbyPageCreatorLastName: parsedJson['last_name'],
      serachNearbyPageCreatorPhoneNumber: parsedJson['phone_number'],
      serachNearbyPageCreatorEmail: parsedJson['email'],
      serachNearbyPageCreatorUserName: parsedJson['username'],
      serachNearbyPageCreatorImage: parsedJson['image']
    );
  }
}