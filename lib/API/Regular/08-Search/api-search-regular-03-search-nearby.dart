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
  int serachNearbyId;
  String serachNearbyName;
  APIRegularSearchNearbyExtendedPageDetails serachNearbyDetails;
  dynamic serachNearbyBackgroundImage;
  dynamic serachNearbyProfileImage;
  dynamic serachNearbyImagesOrVideos;
  String serachNearbyRelationship;
  APIRegularSearchNearbyExtendedPageCreator serachNearbyPageCreator;
  bool serachNearbyManage;
  bool serachNearbyFamOrFriends;
  bool serachNearbyFollower;
  String serachNearbyPageType;
  String serachNearbyPrivacy;

  APIRegularSearchNearbyExtended({this.serachNearbyId, this.serachNearbyName, this.serachNearbyDetails, this.serachNearbyBackgroundImage, this.serachNearbyProfileImage, this.serachNearbyImagesOrVideos, this.serachNearbyRelationship, this.serachNearbyPageCreator, this.serachNearbyManage, this.serachNearbyFamOrFriends, this.serachNearbyFollower, this.serachNearbyPageType, this.serachNearbyPrivacy});

  factory APIRegularSearchNearbyExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularSearchNearbyExtended(
      serachNearbyId: parsedJson['id'],
      serachNearbyName: parsedJson['name'],
      serachNearbyDetails: APIRegularSearchNearbyExtendedPageDetails.fromJson(parsedJson['details']),
      serachNearbyBackgroundImage: parsedJson['backgroundImage'],
      serachNearbyProfileImage: parsedJson['profileImage'],
      serachNearbyImagesOrVideos: parsedJson['imagesOrVideos'],
      serachNearbyRelationship: parsedJson['relationship'],
      serachNearbyPageCreator: APIRegularSearchNearbyExtendedPageCreator.fromJson(parsedJson['page_creator']),
      serachNearbyManage: parsedJson['manage'],
      serachNearbyFamOrFriends: parsedJson['famOrFriends'],
      serachNearbyFollower: parsedJson['follower'],
      serachNearbyPageType: parsedJson['page_type'],
      serachNearbyPrivacy: parsedJson['privacy'],
    );
  }
}

class APIRegularSearchNearbyExtendedPageDetails{
  String serachNearbyPageDetailsDescription;
  String serachNearbyPageDetailsLocation;
  String serachNearbyPageDetailsPrecinct;
  String serachNearbyPageDetailsDob;
  String serachNearbyPageDetailsRip;
  String serachNearbyPageDetailsState;
  String serachNearbyPageDetailsCountry;

  APIRegularSearchNearbyExtendedPageDetails({this.serachNearbyPageDetailsDescription, this.serachNearbyPageDetailsLocation, this.serachNearbyPageDetailsPrecinct, this.serachNearbyPageDetailsDob, this.serachNearbyPageDetailsRip, this.serachNearbyPageDetailsState, this.serachNearbyPageDetailsCountry});

  factory APIRegularSearchNearbyExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularSearchNearbyExtendedPageDetails(
      serachNearbyPageDetailsDescription: parsedJson['description'],
      serachNearbyPageDetailsLocation: parsedJson['location'],
      serachNearbyPageDetailsPrecinct: parsedJson['precinct'],
      serachNearbyPageDetailsDob: parsedJson['dob'],
      serachNearbyPageDetailsRip: parsedJson['rip'],
      serachNearbyPageDetailsState: parsedJson['state'],
      serachNearbyPageDetailsCountry: parsedJson['country'],
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