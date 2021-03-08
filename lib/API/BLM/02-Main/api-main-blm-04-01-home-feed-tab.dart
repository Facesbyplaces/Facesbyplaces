import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMHomeTabFeedMain> apiBLMHomeFeedTab({required int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get(
    Uri.http('http://fbp.dev1.koda.ws/api/v1/mainpages/feed/?page=$page', ''),
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

  APIBLMHomeTabFeedMain({required this.blmFamilyMemorialList, required this.blmItemsRemaining});

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

  APIBLMHomeTabFeedExtended({required this.homeTabFeedId, required this.homeTabFeedPage, required this.homeTabFeedBody, required this.homeTabFeedLocation, required this.homeTabFeedLatitude, required this.homeTabFeedLongitude, required this.homeTabFeedImagesOrVideos, required this.homeTabFeedPostTagged, required this.homeTabFeedCreatedAt, required this.homeTabFeedNumberOfLikes, required this.homeTabFeedNumberOfComments, required this.homeTabFeedLikeStatus});

  factory APIBLMHomeTabFeedExtended.fromJson(Map<String, dynamic> parsedJson){
    
    List<dynamic>? newList1;

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
      homeTabFeedImagesOrVideos: newList1!,
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

  APIBLMHomeTabFeedExtendedPage({required this.homeTabFeedPageId, required this.homeTabFeedPageName, required this.homeTabFeedPageDetails, required this.homeTabFeedPageBackgroundImage, required this.homeTabFeedPageProfileImage, required this.homeTabFeedPageImagesOrVideos, required this.homeTabFeedPageRelationship, required this.homeTabFeedPagePageCreator, required this.homeTabFeedPageManage, required this.homeTabFeedPageFamOrFriends, required this.homeTabFeedPageFollower, required this.homeTabFeedPagePageType, required this.homeTabFeedPagePrivacy});

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

  APIBLMHomeTabFeedExtendedPageDetails({required this.homeTabFeedPageDetailsDescription, required this.homeTabFeedPageDetailsBirthPlace, required this.homeTabFeedPageDetailsDob, required this.homeTabFeedPageDetailsRip, required this.homeTabFeedPageDetailsCemetery, required this.homeTabFeedPageDetailsCountry});

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

  APIBLMHomeTabFeedExtendedPageCreator({required this.homeTabFeedPageCreatorId, required this.homeTabFeedPageCreatorFirstName, required this.homeTabFeedPageCreatorLastName, required this.homeTabFeedPageCreatorPhoneNumber, required this.homeTabFeedPageCreatorEmail, required this.homeTabFeedPageCreatorUserName, required this.homeTabFeedPageCreatorImage});

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

  APIBLMHomeTabFeedExtendedTagged({required this.homeTabFeedTaggedId, required this.homeTabFeedTaggedFirstName, required this.homeTabFeedTaggedLastName, required this.homeTabFeedTaggedImage});

  factory APIBLMHomeTabFeedExtendedTagged.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeTabFeedExtendedTagged(
      homeTabFeedTaggedId: parsedJson['id'],
      homeTabFeedTaggedFirstName: parsedJson['first_name'],
      homeTabFeedTaggedLastName: parsedJson['last_name'],
      homeTabFeedTaggedImage: parsedJson['image']
    );
  }
}