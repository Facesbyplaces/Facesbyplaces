import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularHomeTabFeedMain> apiRegularHomeFeedTab({int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

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
    return APIRegularHomeTabFeedMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the feed');
  }
}

class APIRegularHomeTabFeedMain{
  int almItemsRemaining;
  List<APIRegularHomeTabFeedExtended> almFamilyMemorialList;

  APIRegularHomeTabFeedMain({this.almItemsRemaining, this.almFamilyMemorialList});

  factory APIRegularHomeTabFeedMain.fromJson(Map<String, dynamic> parsedJson){
    var newList = parsedJson['posts'] as List;
    List<APIRegularHomeTabFeedExtended> familyMemorials = newList.map((i) => APIRegularHomeTabFeedExtended.fromJson(i)).toList();

    return APIRegularHomeTabFeedMain(
      almItemsRemaining: parsedJson['itemsremaining'],
      almFamilyMemorialList: familyMemorials,
    );
  }
}

class APIRegularHomeTabFeedExtended{
  int homeTabFeedId;
  APIRegularHomeTabFeedExtendedPage homeTabFeedPage;
  String homeTabFeedBody;
  String homeTabFeedLocation;
  double homeTabFeedLatitude;
  double homeTabFeedLongitude;
  List<dynamic> homeTabFeedImagesOrVideos;
  List<APIRegularHomeTabFeedExtendedTagged> homeTabFeedPostTagged;
  String homeTabFeedCreateAt;
  int homeTabFeedNumberOfLikes;
  int homeTabFeedNumberOfComments;
  bool homeTabFeedLikeStatus;

  APIRegularHomeTabFeedExtended({this.homeTabFeedId, this.homeTabFeedPage, this.homeTabFeedBody, this.homeTabFeedLocation, this.homeTabFeedLatitude, this.homeTabFeedLongitude, this.homeTabFeedImagesOrVideos, this.homeTabFeedPostTagged, this.homeTabFeedCreateAt, this.homeTabFeedNumberOfLikes, this.homeTabFeedNumberOfComments, this.homeTabFeedLikeStatus});

  factory APIRegularHomeTabFeedExtended.fromJson(Map<String, dynamic> parsedJson){
    
    List<dynamic> newList1;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList1 = List<dynamic>.from(list);
    }

    var newList2 = parsedJson['tag_people'] as List;
    List<APIRegularHomeTabFeedExtendedTagged> taggedList = newList2.map((i) => APIRegularHomeTabFeedExtendedTagged.fromJson(i)).toList();
    
    return APIRegularHomeTabFeedExtended(
      homeTabFeedId: parsedJson['id'],
      homeTabFeedPage: APIRegularHomeTabFeedExtendedPage.fromJson(parsedJson['page']),
      homeTabFeedBody: parsedJson['body'],
      homeTabFeedLocation: parsedJson['location'],
      homeTabFeedLatitude: parsedJson['latitude'],
      homeTabFeedLongitude: parsedJson['longitude'],
      homeTabFeedImagesOrVideos: newList1,
      homeTabFeedPostTagged: taggedList,
      homeTabFeedCreateAt: parsedJson['created_at'],
      homeTabFeedNumberOfLikes: parsedJson['numberOfLikes'],
      homeTabFeedNumberOfComments: parsedJson['numberOfComments'],
      homeTabFeedLikeStatus: parsedJson['likeStatus'],
    );
  }
}

class APIRegularHomeTabFeedExtendedPage{
  int homeTabFeedPageId;
  String homeTabFeedPageName;
  APIRegularHomeTabFeedExtendedPageDetails homeTabFeedPageDetails;
  dynamic homeTabFeedPageBackgroundImage;
  dynamic homeTabFeedPageProfileImage;
  dynamic homeTabFeedPageImagesOrVideos;
  String homeTabFeedPageRelationship;
  APIRegularHomeTabFeedExtendedPageCreator homeTabFeedPagePageCreator;
  bool homeTabFeedPageManage;
  bool homeTabFeedPageFamOrFriends;
  bool homeTabFeedPageFollower;
  String homeTabFeedPagePageType;
  String homeTabFeedPagePrivacy;

  APIRegularHomeTabFeedExtendedPage({this.homeTabFeedPageId, this.homeTabFeedPageName, this.homeTabFeedPageDetails, this.homeTabFeedPageBackgroundImage, this.homeTabFeedPageProfileImage, this.homeTabFeedPageImagesOrVideos, this.homeTabFeedPageRelationship, this.homeTabFeedPagePageCreator, this.homeTabFeedPageFollower, this.homeTabFeedPageManage, this.homeTabFeedPagePageType, this.homeTabFeedPagePrivacy});

  factory APIRegularHomeTabFeedExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeTabFeedExtendedPage(
      homeTabFeedPageId: parsedJson['id'],
      homeTabFeedPageName: parsedJson['name'],
      homeTabFeedPageDetails: APIRegularHomeTabFeedExtendedPageDetails.fromJson(parsedJson['details']),
      homeTabFeedPageBackgroundImage: parsedJson['backgroundImage'],
      homeTabFeedPageProfileImage: parsedJson['profileImage'],
      homeTabFeedPageImagesOrVideos: parsedJson['imagesOrVideos'],
      homeTabFeedPageRelationship: parsedJson['relationship'],
      homeTabFeedPagePageCreator: APIRegularHomeTabFeedExtendedPageCreator.fromJson(parsedJson['page_creator']),
      homeTabFeedPageFollower: parsedJson['follower'],
      homeTabFeedPageManage: parsedJson['manage'],
      homeTabFeedPagePageType: parsedJson['page_type'],
      homeTabFeedPagePrivacy: parsedJson['privacy'],
    );
  }
}

class APIRegularHomeTabFeedExtendedPageDetails{
  String homeTabFeedPageDetailsDescription;
  String homeTabFeedPageDetailsBirthPlace;
  String homeTabFeedPageDetailsDob;
  String homeTabFeedPageDetailsRip;
  String homeTabFeedPageDetailsCemetery;
  String homeTabFeedPageDetailsCountry;

  APIRegularHomeTabFeedExtendedPageDetails({this.homeTabFeedPageDetailsDescription, this.homeTabFeedPageDetailsBirthPlace, this.homeTabFeedPageDetailsDob, this.homeTabFeedPageDetailsRip, this.homeTabFeedPageDetailsCemetery, this.homeTabFeedPageDetailsCountry});

  factory APIRegularHomeTabFeedExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeTabFeedExtendedPageDetails(
      homeTabFeedPageDetailsDescription: parsedJson['description'],
      homeTabFeedPageDetailsBirthPlace: parsedJson['birthplace'],
      homeTabFeedPageDetailsDob: parsedJson['dob'],
      homeTabFeedPageDetailsRip: parsedJson['rip'],
      homeTabFeedPageDetailsCemetery: parsedJson['cemetery'],
      homeTabFeedPageDetailsCountry: parsedJson['country'],
    );
  }
}

class APIRegularHomeTabFeedExtendedPageCreator{
  int homeTabFeedPageCreatorId;
  String homeTabFeedPageCreatorFirstName;
  String homeTabFeedPageCreatorLastName;
  String homeTabFeedPageCreatorPhoneNumber;
  String homeTabFeedPageCreatorEmail;
  String homeTabFeedPageCreatorUserName;
  dynamic homeTabFeedPageCreatorImage;

  APIRegularHomeTabFeedExtendedPageCreator({this.homeTabFeedPageCreatorId, this.homeTabFeedPageCreatorFirstName, this.homeTabFeedPageCreatorLastName, this.homeTabFeedPageCreatorPhoneNumber, this.homeTabFeedPageCreatorEmail, this.homeTabFeedPageCreatorUserName, this.homeTabFeedPageCreatorImage});

  factory APIRegularHomeTabFeedExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeTabFeedExtendedPageCreator(
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

class APIRegularHomeTabFeedExtendedTagged{
  int homeTabFeedTaggedId;
  String homeTabFeedTaggedFirstName;
  String homeTabFeedTaggedLastName;
  String homeTabFeedTaggedImage;

  APIRegularHomeTabFeedExtendedTagged({this.homeTabFeedTaggedId, this.homeTabFeedTaggedFirstName, this.homeTabFeedTaggedLastName, this.homeTabFeedTaggedImage});

  factory APIRegularHomeTabFeedExtendedTagged.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeTabFeedExtendedTagged(
      homeTabFeedTaggedId: parsedJson['id'],
      homeTabFeedTaggedFirstName: parsedJson['first_name'],
      homeTabFeedTaggedLastName: parsedJson['last_name'],
      homeTabFeedTaggedImage: parsedJson['image']
    );
  }
}