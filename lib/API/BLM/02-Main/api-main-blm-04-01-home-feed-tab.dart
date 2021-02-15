import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMHomeTabFeedMain> apiBLMHomeFeedTab({int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/mainpages/feed/?page=$page',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMHomeTabFeedMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the feed');
  }
}

class APIBLMHomeTabFeedMain{
  int blmItemsRemaining;
  List<APIBLMHomeTabFeedExtended> blmFamilyMemorialList;

  APIBLMHomeTabFeedMain({this.blmFamilyMemorialList, this.blmItemsRemaining});

  factory APIBLMHomeTabFeedMain.fromJson(Map<String, dynamic> parsedJson){
    var newList = parsedJson['posts'] as List;
    List<APIBLMHomeTabFeedExtended> familyMemorials = newList.map((i) => APIBLMHomeTabFeedExtended.fromJson(i)).toList();

    return APIBLMHomeTabFeedMain(
      blmFamilyMemorialList: familyMemorials,
      blmItemsRemaining: parsedJson['itemsremaining'],
    );
  }
}

class APIBLMHomeTabFeedExtended{
  int homeTabFeedId;
  APIBLMHomeTabFeedExtendedPage homeTabFeedPage;
  String homeTabFeedBody;
  String homeTabFeedLocation;
  double homeTabFeedLatitude;
  double homeTabFeedLongitude;
  List<dynamic> homeTabFeedImagesOrVideos;
  List<APIBLMHomeTabFeedExtendedTagged> homeTabFeedPostTagged;
  String homeTabFeedCreatedAt;
  int homeTabFeedNumberOfLikes;
  int homeTabFeedNumberOfComments;
  bool homeTabFeedLikeStatus;

  APIBLMHomeTabFeedExtended({this.homeTabFeedId, this.homeTabFeedPage, this.homeTabFeedBody, this.homeTabFeedLocation, this.homeTabFeedLatitude, this.homeTabFeedLongitude, this.homeTabFeedImagesOrVideos, this.homeTabFeedPostTagged, this.homeTabFeedCreatedAt, this.homeTabFeedNumberOfLikes, this.homeTabFeedNumberOfComments, this.homeTabFeedLikeStatus});

  factory APIBLMHomeTabFeedExtended.fromJson(Map<String, dynamic> parsedJson){
    
    List<dynamic> newList1;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList1 = List<dynamic>.from(list);
    }

    var newList2 = parsedJson['tag_people'] as List;
    List<APIBLMHomeTabFeedExtendedTagged> taggedList = newList2.map((i) => APIBLMHomeTabFeedExtendedTagged.fromJson(i)).toList();
    
    return APIBLMHomeTabFeedExtended(
      homeTabFeedId: parsedJson['id'],
      homeTabFeedPage: APIBLMHomeTabFeedExtendedPage.fromJson(parsedJson['page']),
      homeTabFeedBody: parsedJson['body'],
      homeTabFeedLocation: parsedJson['location'],
      homeTabFeedLatitude: parsedJson['latitude'],
      homeTabFeedLongitude: parsedJson['longitude'],
      homeTabFeedImagesOrVideos: newList1,
      homeTabFeedPostTagged: taggedList,
      homeTabFeedCreatedAt: parsedJson['created_at'],
      homeTabFeedNumberOfLikes: parsedJson['numberOfLikes'],
      homeTabFeedNumberOfComments: parsedJson['numberOfComments'],
      homeTabFeedLikeStatus: parsedJson['likeStatus'],
    );
  }
}

class APIBLMHomeTabFeedExtendedPage{
  int homeTabFeedPageId;
  String homeTabFeedPageName;
  APIBLMHomeTabFeedExtendedPageDetails homeTabFeedPageDetails;
  dynamic homeTabFeedPageBackgroundImage;
  dynamic homeTabFeedPageProfileImage;
  dynamic homeTabFeedPageImagesOrVideos;
  String homeTabFeedPageRelationship;
  APIBLMHomeTabFeedExtendedPageCreator homeTabFeedPagePageCreator;
  bool homeTabFeedPageManage;
  bool homeTabFeedPageFamOrFriends;
  bool homeTabFeedPageFollower;
  String homeTabFeedPagePageType;
  String homeTabFeedPagePrivacy;

  APIBLMHomeTabFeedExtendedPage({this.homeTabFeedPageId, this.homeTabFeedPageName, this.homeTabFeedPageDetails, this.homeTabFeedPageBackgroundImage, this.homeTabFeedPageProfileImage, this.homeTabFeedPageImagesOrVideos, this.homeTabFeedPageRelationship, this.homeTabFeedPagePageCreator, this.homeTabFeedPageManage, this.homeTabFeedPageFamOrFriends, this.homeTabFeedPageFollower, this.homeTabFeedPagePageType, this.homeTabFeedPagePrivacy});

  factory APIBLMHomeTabFeedExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeTabFeedExtendedPage(
      homeTabFeedPageId: parsedJson['id'],
      homeTabFeedPageName: parsedJson['name'],
      homeTabFeedPageDetails: APIBLMHomeTabFeedExtendedPageDetails.fromJson(parsedJson['details']),
      homeTabFeedPageBackgroundImage: parsedJson['backgroundImage'],
      homeTabFeedPageProfileImage: parsedJson['profileImage'],
      homeTabFeedPageImagesOrVideos: parsedJson['imagesOrVideos'],
      homeTabFeedPageRelationship: parsedJson['relationship'],
      homeTabFeedPagePageCreator: APIBLMHomeTabFeedExtendedPageCreator.fromJson(parsedJson['page_creator']),
      homeTabFeedPageManage: parsedJson['manage'],
      homeTabFeedPageFamOrFriends: parsedJson['famOrFriends'],
      homeTabFeedPageFollower: parsedJson['follower'],
      homeTabFeedPagePageType: parsedJson['page_type'],
      homeTabFeedPagePrivacy: parsedJson['privacy'],
    );
  }
}

class APIBLMHomeTabFeedExtendedPageDetails{
  String homeTabFeedPageDetailsDescription;
  String homeTabFeedPageDetailsBirthPlace;
  String homeTabFeedPageDetailsDob;
  String homeTabFeedPageDetailsRip;
  String homeTabFeedPageDetailsCemetery;
  String homeTabFeedPageDetailsCountry;

  APIBLMHomeTabFeedExtendedPageDetails({this.homeTabFeedPageDetailsDescription, this.homeTabFeedPageDetailsBirthPlace, this.homeTabFeedPageDetailsDob, this.homeTabFeedPageDetailsRip, this.homeTabFeedPageDetailsCemetery, this.homeTabFeedPageDetailsCountry});

  factory APIBLMHomeTabFeedExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeTabFeedExtendedPageDetails(
      homeTabFeedPageDetailsDescription: parsedJson['description'],
      homeTabFeedPageDetailsBirthPlace: parsedJson['birthplace'],
      homeTabFeedPageDetailsDob: parsedJson['dob'],
      homeTabFeedPageDetailsRip: parsedJson['rip'],
      homeTabFeedPageDetailsCemetery: parsedJson['cemetery'],
      homeTabFeedPageDetailsCountry: parsedJson['country'],
    );
  }
}

class APIBLMHomeTabFeedExtendedPageCreator{
  int homeTabFeedPageCreatorId;
  String homeTabFeedPageCreatorFirstName;
  String homeTabFeedPageCreatorLastName;
  String homeTabFeedPageCreatorPhoneNumber;
  String homeTabFeedPageCreatorEmail;
  String homeTabFeedPageCreatorUserName;
  dynamic homeTabFeedPageCreatorImage;

  APIBLMHomeTabFeedExtendedPageCreator({this.homeTabFeedPageCreatorId, this.homeTabFeedPageCreatorFirstName, this.homeTabFeedPageCreatorLastName, this.homeTabFeedPageCreatorPhoneNumber, this.homeTabFeedPageCreatorEmail, this.homeTabFeedPageCreatorUserName, this.homeTabFeedPageCreatorImage});

  factory APIBLMHomeTabFeedExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeTabFeedExtendedPageCreator(
      homeTabFeedPageCreatorId: parsedJson['id'],
      homeTabFeedPageCreatorFirstName: parsedJson['first_name'],
      homeTabFeedPageCreatorLastName: parsedJson['last_name'],
      homeTabFeedPageCreatorPhoneNumber: parsedJson['phone_number'],
      homeTabFeedPageCreatorEmail: parsedJson['email'],
      homeTabFeedPageCreatorUserName: parsedJson['username'],
      homeTabFeedPageCreatorImage: parsedJson['image']
    );
  }
}

class APIBLMHomeTabFeedExtendedTagged{
  int homeTabFeedTaggedId;
  String homeTabFeedTaggedFirstName;
  String homeTabFeedTaggedLastName;
  String homeTabFeedTaggedImage;

  APIBLMHomeTabFeedExtendedTagged({this.homeTabFeedTaggedId, this.homeTabFeedTaggedFirstName, this.homeTabFeedTaggedLastName, this.homeTabFeedTaggedImage});

  factory APIBLMHomeTabFeedExtendedTagged.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeTabFeedExtendedTagged(
      homeTabFeedTaggedId: parsedJson['id'],
      homeTabFeedTaggedFirstName: parsedJson['first_name'],
      homeTabFeedTaggedLastName: parsedJson['last_name'],
      homeTabFeedTaggedImage: parsedJson['image']
    );
  }
}