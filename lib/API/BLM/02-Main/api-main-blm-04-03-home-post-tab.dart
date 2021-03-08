import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMHomeTabPostMain> apiBLMHomePostTab({required int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get(
    Uri.http('http://fbp.dev1.koda.ws/api/v1/mainpages/posts/?page=$page', ''),
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

  APIBLMHomeTabPostMain({required this.blmItemsRemaining, required this.blmFamilyMemorialList});

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

  APIBLMHomeTabPostExtended({required this.homeTabPostId, required this.homeTabPostPage, required this.homeTabPostBody, required this.homeTabPostLocation, required this.homeTabPostLatitude, required this.homeTabPostLongitude, required this.homeTabPostImagesOrVideos, required this.homeTabPostPostTagged, required this.homeTabPostCreatedAt, required this.homeTabPostNumberOfLikes, required this.homeTabPostNumberOfComments, required this.homeTabPostLikeStatus});

  factory APIBLMHomeTabPostExtended.fromJson(Map<String, dynamic> parsedJson){
    
    List<dynamic>? newList1;

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
      homeTabPostImagesOrVideos: newList1!,
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

  APIBLMHomeTabPostExtendedPage({required this.homeTabPostPageId, required this.homeTabPostPageName, required this.homeTabPostPageDetails, required this.homeTabPostPageBackgroundImage, required this.homeTabPostPageProfileImage, required this.homeTabPostPageImagesOrVideos, required this.homeTabPostPageRelationship, required this.homeTabPostPagePageCreator, required this.homeTabPostPageManage, required this.homeTabPostPageFamOrFriends, required this.homeTabPostPageFollower, required this.homeTabPostPagePageType, required this.homeTabPostPagePrivacy});

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

  APIBLMHomeTabPostExtendedPageDetails({required this.homeTabPostPageDetailsDescription, required this.homeTabPostPageDetailsBirthPlace, required this.homeTabPostPageDetailsDob, required this.homeTabPostPageDetailsRip, required this.homeTabPostPageDetailsCemetery, required this.homeTabPostPageDetailsCountry});

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

  APIBLMHomeTabPostExtendedPageCreator({required this.homeTabPostPageCreatorId, required this.homeTabPostPageCreatorFirstName, required this.homeTabPostPageCreatorLastName, required this.homeTabPostPageCreatorPhoneNumber, required this.homeTabPostPageCreatorEmail, required this.homeTabPostPageCreatorUserName, required this.homeTabPostPageCreatorImage});

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

  APIBLMHomeTabPostExtendedTagged({required this.homeTabPostTabTaggedId, required this.homeTabPostTabTaggedFirstName, required this.homeTabPostTabTaggedLastName, required this.homeTabPostTabTaggedImage});

  factory APIBLMHomeTabPostExtendedTagged.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeTabPostExtendedTagged(
      homeTabPostTabTaggedId: parsedJson['id'],
      homeTabPostTabTaggedFirstName: parsedJson['first_name'],
      homeTabPostTabTaggedLastName: parsedJson['last_name'],
      homeTabPostTabTaggedImage: parsedJson['image']
    );
  }
}