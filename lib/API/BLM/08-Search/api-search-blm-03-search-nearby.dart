import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMSearchPostMain> apiBLMSearchNearby({int page, double latitude, double longitude}) async{

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
    return APIBLMSearchPostMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the feed');
  }
}

class APIBLMSearchPostMain{
  int blmItemsRemaining;
  int memorialItemsRemaining;
  List<APIBLMSearchPostExtended> blmList;
  List<APIBLMSearchPostExtended> memorialList;

  APIBLMSearchPostMain({this.blmItemsRemaining, this.memorialItemsRemaining, this.blmList, this.memorialList});

  factory APIBLMSearchPostMain.fromJson(Map<String, dynamic> parsedJson){
    var newList1 = parsedJson['blm'] as List;
    var newList2 = parsedJson['memorial'] as List;

    List<APIBLMSearchPostExtended> blmList = newList1.map((i) => APIBLMSearchPostExtended.fromJson(i)).toList();
    List<APIBLMSearchPostExtended> memorialList = newList2.map((e) => APIBLMSearchPostExtended.fromJson(e)).toList();

    return APIBLMSearchPostMain(
      blmItemsRemaining: parsedJson['blmItemsRemaining'],
      memorialItemsRemaining: parsedJson['memorialItemsRemaining'],
      blmList: blmList,
      memorialList: memorialList,
    );
  }
}


class APIBLMSearchPostExtended{
  int searchPostId;
  String searchPostName;
  APIBLMPostExtendedPageDetails searchPostDetails;
  dynamic searchPostBackgroundImage;
  dynamic searchPostProfileImage;
  dynamic searchPostImagesOrVideos;
  String searchPostRelationship;
  APIBLMHomeTabPostExtendedPageCreator searchPostPageCreator;
  bool searchPostManage;
  bool searchPostFamOrFriends;
  bool searchPostFollower;
  String searchPostPageType;
  String searchPostPrivacy;


  APIBLMSearchPostExtended({this.searchPostId, this.searchPostName, this.searchPostDetails, this.searchPostBackgroundImage, this.searchPostProfileImage, this.searchPostImagesOrVideos, this.searchPostRelationship, this.searchPostPageCreator, this.searchPostManage, this.searchPostFamOrFriends, this.searchPostFollower, this.searchPostPageType, this.searchPostPrivacy});

  factory APIBLMSearchPostExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMSearchPostExtended(
      searchPostId: parsedJson['id'],
      searchPostName: parsedJson['name'],
      searchPostDetails: APIBLMPostExtendedPageDetails.fromJson(parsedJson['details']),
      searchPostBackgroundImage: parsedJson['backgroundImage'],
      searchPostProfileImage: parsedJson['profileImage'],
      searchPostImagesOrVideos: parsedJson['imagesOrVideos'],
      searchPostRelationship: parsedJson['relationship'],
      searchPostPageCreator: APIBLMHomeTabPostExtendedPageCreator.fromJson(parsedJson['page_creator']),
      searchPostManage: parsedJson['manage'],
      searchPostFamOrFriends: parsedJson['famOrFriends'],
      searchPostFollower: parsedJson['follower'],
      searchPostPageType: parsedJson['page_type'],
      searchPostPrivacy: parsedJson['privacy'],
    );
  }
}

class APIBLMPostExtendedPageDetails{
  String searchPostPageDetailsDescription;
  String searchPostPageDetailsLocation;
  String searchPostPageDetailsPrecinct;
  String searchPostPageDetailsDob;
  String searchPostPageDetailsRip;
  String searchPostPageDetailsState;
  String searchPostPageDetailsCountry;

  APIBLMPostExtendedPageDetails({this.searchPostPageDetailsDescription, this.searchPostPageDetailsLocation, this.searchPostPageDetailsPrecinct, this.searchPostPageDetailsDob, this.searchPostPageDetailsRip, this.searchPostPageDetailsState, this.searchPostPageDetailsCountry});

  factory APIBLMPostExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMPostExtendedPageDetails(
      searchPostPageDetailsDescription: parsedJson['description'],
      searchPostPageDetailsLocation: parsedJson['location'],
      searchPostPageDetailsPrecinct: parsedJson['precinct'],
      searchPostPageDetailsDob: parsedJson['dob'],
      searchPostPageDetailsRip: parsedJson['rip'],
      searchPostPageDetailsState: parsedJson['state'],
      searchPostPageDetailsCountry: parsedJson['country'],
    );
  }
}

class APIBLMHomeTabPostExtendedPageCreator{
  int searchPostPageCreatorId;
  String searchPostPageCreatorFirstName;
  String searchPostPageCreatorLastName;
  String searchPostPageCreatorPhoneNumber;
  String searchPostPageCreatorEmail;
  String searchPostPageCreatorUserName;
  dynamic searchPostPageCreatorImage;

  APIBLMHomeTabPostExtendedPageCreator({this.searchPostPageCreatorId, this.searchPostPageCreatorFirstName, this.searchPostPageCreatorLastName, this.searchPostPageCreatorPhoneNumber, this.searchPostPageCreatorEmail, this.searchPostPageCreatorUserName, this.searchPostPageCreatorImage});

  factory APIBLMHomeTabPostExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeTabPostExtendedPageCreator(
      searchPostPageCreatorId: parsedJson['id'],
      searchPostPageCreatorFirstName: parsedJson['first_name'],
      searchPostPageCreatorLastName: parsedJson['last_name'],
      searchPostPageCreatorPhoneNumber: parsedJson['phone_number'],
      searchPostPageCreatorEmail: parsedJson['email'],
      searchPostPageCreatorUserName: parsedJson['username'],
      searchPostPageCreatorImage: parsedJson['image']
    );
  }
}