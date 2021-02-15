import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMHomeTabPostMain> apiBLMHomePostTab({int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/mainpages/posts/?page=$page',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMHomeTabPostMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the post');
  }
}

class APIBLMHomeTabPostMain{
  int blmItemsRemaining;
  List<APIBLMHomeTabPostExtended> blmFamilyMemorialList;

  APIBLMHomeTabPostMain({this.blmItemsRemaining, this.blmFamilyMemorialList});

  factory APIBLMHomeTabPostMain.fromJson(Map<String, dynamic> parsedJson){
    var newList = parsedJson['posts'] as List;
    List<APIBLMHomeTabPostExtended> familyMemorials = newList.map((i) => APIBLMHomeTabPostExtended.fromJson(i)).toList();

    return APIBLMHomeTabPostMain(
      blmItemsRemaining: parsedJson['itemsremaining'],
      blmFamilyMemorialList: familyMemorials,
    );
  }
}

class APIBLMHomeTabPostExtended{
  int homeTabPostId;
  APIBLMHomeTabPostExtendedPage homeTabPostPage;
  String homeTabPostBody;
  String homeTabPostLocation;
  double homeTabPostLatitude;
  double homeTabPostLongitude;
  List<dynamic> homeTabPostImagesOrVideos;
  List<APIBLMHomeTabPostExtendedTagged> homeTabPostPostTagged;
  String homeTabPostCreatedAt;
  int homeTabPostNumberOfLikes;
  int homeTabPostNumberOfComments;
  bool homeTabPostLikeStatus;

  APIBLMHomeTabPostExtended({this.homeTabPostId, this.homeTabPostPage, this.homeTabPostBody, this.homeTabPostLocation, this.homeTabPostLatitude, this.homeTabPostLongitude, this.homeTabPostImagesOrVideos, this.homeTabPostPostTagged, this.homeTabPostCreatedAt, this.homeTabPostNumberOfLikes, this.homeTabPostNumberOfComments, this.homeTabPostLikeStatus});

  factory APIBLMHomeTabPostExtended.fromJson(Map<String, dynamic> parsedJson){
    
    List<dynamic> newList1;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList1 = List<dynamic>.from(list);
    }

    var newList2 = parsedJson['tag_people'] as List;
    List<APIBLMHomeTabPostExtendedTagged> taggedList = newList2.map((i) => APIBLMHomeTabPostExtendedTagged.fromJson(i)).toList();
    
    return APIBLMHomeTabPostExtended(
      homeTabPostId: parsedJson['id'],
      homeTabPostPage: APIBLMHomeTabPostExtendedPage.fromJson(parsedJson['page']),
      homeTabPostBody: parsedJson['body'],
      homeTabPostLocation: parsedJson['location'],
      homeTabPostLatitude: parsedJson['latitude'],
      homeTabPostLongitude: parsedJson['longitude'],
      homeTabPostImagesOrVideos: newList1,
      homeTabPostPostTagged: taggedList,
      homeTabPostCreatedAt: parsedJson['created_at'],
      homeTabPostNumberOfLikes: parsedJson['numberOfLikes'],
      homeTabPostNumberOfComments: parsedJson['numberOfComments'],
      homeTabPostLikeStatus: parsedJson['likeStatus'],
    );
  }
}

class APIBLMHomeTabPostExtendedPage{
  int homeTabPostPageId;
  String homeTabPostPageName;
  APIBLMHomeTabPostExtendedPageDetails homeTabPostPageDetails;
  dynamic homeTabPostPageBackgroundImage;
  dynamic homeTabPostPageProfileImage;
  dynamic homeTabPostPageImagesOrVideos;
  String homeTabPostPageRelationship;
  APIBLMHomeTabPostExtendedPageCreator homeTabPostPagePageCreator;
  bool homeTabPostPageManage;
  bool homeTabPostPageFamOrFriends;
  bool homeTabPostPageFollower;
  String homeTabPostPagePageType;
  String homeTabPostPagePrivacy;

  APIBLMHomeTabPostExtendedPage({this.homeTabPostPageId, this.homeTabPostPageName, this.homeTabPostPageDetails, this.homeTabPostPageBackgroundImage, this.homeTabPostPageProfileImage, this.homeTabPostPageImagesOrVideos, this.homeTabPostPageRelationship, this.homeTabPostPagePageCreator, this.homeTabPostPageManage, this.homeTabPostPageFamOrFriends, this.homeTabPostPageFollower, this.homeTabPostPagePageType, this.homeTabPostPagePrivacy});

  factory APIBLMHomeTabPostExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeTabPostExtendedPage(
      homeTabPostPageId: parsedJson['id'],
      homeTabPostPageName: parsedJson['name'],
      homeTabPostPageDetails: APIBLMHomeTabPostExtendedPageDetails.fromJson(parsedJson['details']),
      homeTabPostPageBackgroundImage: parsedJson['backgroundImage'],
      homeTabPostPageProfileImage: parsedJson['profileImage'],
      homeTabPostPageImagesOrVideos: parsedJson['imagesOrVideos'],
      homeTabPostPageRelationship: parsedJson['relationship'],
      homeTabPostPagePageCreator: APIBLMHomeTabPostExtendedPageCreator.fromJson(parsedJson['page_creator']),
      homeTabPostPageManage: parsedJson['manage'],
      homeTabPostPageFamOrFriends: parsedJson['famOrFriends'],
      homeTabPostPageFollower: parsedJson['follower'],
      homeTabPostPagePageType: parsedJson['page_type'],
      homeTabPostPagePrivacy: parsedJson['privacy'],
    );
  }
}

class APIBLMHomeTabPostExtendedPageDetails{
  String homeTabPostPageDetailsDescription;
  String homeTabPostPageDetailsBirthPlace;
  String homeTabPostPageDetailsDob;
  String homeTabPostPageDetailsRip;
  String homeTabPostPageDetailsCemetery;
  String homeTabPostPageDetailsCountry;

  APIBLMHomeTabPostExtendedPageDetails({this.homeTabPostPageDetailsDescription, this.homeTabPostPageDetailsBirthPlace, this.homeTabPostPageDetailsDob, this.homeTabPostPageDetailsRip, this.homeTabPostPageDetailsCemetery, this.homeTabPostPageDetailsCountry});

  factory APIBLMHomeTabPostExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeTabPostExtendedPageDetails(
      homeTabPostPageDetailsDescription: parsedJson['description'],
      homeTabPostPageDetailsBirthPlace: parsedJson['birthplace'],
      homeTabPostPageDetailsDob: parsedJson['dob'],
      homeTabPostPageDetailsRip: parsedJson['rip'],
      homeTabPostPageDetailsCemetery: parsedJson['cemetery'],
      homeTabPostPageDetailsCountry: parsedJson['country'],
    );
  }
}

class APIBLMHomeTabPostExtendedPageCreator{
  int homeTabPostPageCreatorId;
  String homeTabPostPageCreatorFirstName;
  String homeTabPostPageCreatorLastName;
  String homeTabPostPageCreatorPhoneNumber;
  String homeTabPostPageCreatorEmail;
  String homeTabPostPageCreatorUserName;
  dynamic homeTabPostPageCreatorImage;

  APIBLMHomeTabPostExtendedPageCreator({this.homeTabPostPageCreatorId, this.homeTabPostPageCreatorFirstName, this.homeTabPostPageCreatorLastName, this.homeTabPostPageCreatorPhoneNumber, this.homeTabPostPageCreatorEmail, this.homeTabPostPageCreatorUserName, this.homeTabPostPageCreatorImage});

  factory APIBLMHomeTabPostExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeTabPostExtendedPageCreator(
      homeTabPostPageCreatorId: parsedJson['id'],
      homeTabPostPageCreatorFirstName: parsedJson['first_name'],
      homeTabPostPageCreatorLastName: parsedJson['last_name'],
      homeTabPostPageCreatorPhoneNumber: parsedJson['phone_number'],
      homeTabPostPageCreatorEmail: parsedJson['email'],
      homeTabPostPageCreatorUserName: parsedJson['username'],
      homeTabPostPageCreatorImage: parsedJson['image']
    );
  }
}

class APIBLMHomeTabPostExtendedTagged{
  int homeTabPostTabTaggedId;
  String homeTabPostTabTaggedFirstName;
  String homeTabPostTabTaggedLastName;
  String homeTabPostTabTaggedImage;

  APIBLMHomeTabPostExtendedTagged({this.homeTabPostTabTaggedId, this.homeTabPostTabTaggedFirstName, this.homeTabPostTabTaggedLastName, this.homeTabPostTabTaggedImage});

  factory APIBLMHomeTabPostExtendedTagged.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeTabPostExtendedTagged(
      homeTabPostTabTaggedId: parsedJson['id'],
      homeTabPostTabTaggedFirstName: parsedJson['first_name'],
      homeTabPostTabTaggedLastName: parsedJson['last_name'],
      homeTabPostTabTaggedImage: parsedJson['image']
    );
  }
}