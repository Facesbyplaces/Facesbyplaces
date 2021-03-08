import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMHomeProfilePostMain> apiBLMProfilePost({required int memorialId, required int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get(
    Uri.http('http://fbp.dev1.koda.ws/api/v1/posts/page/Blm/$memorialId?page=$page', ''),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMHomeProfilePostMain.fromJson(newValue);
  }else{
    throw Exception('Failed to show profile posts');
  }
}

class APIBLMHomeProfilePostMain{
  int blmItemsRemaining;
  List<APIBLMHomeProfilePostExtended> blmFamilyMemorialList;

  APIBLMHomeProfilePostMain({required this.blmItemsRemaining, required this.blmFamilyMemorialList});

  factory APIBLMHomeProfilePostMain.fromJson(Map<String, dynamic> parsedJson){
    var newList = parsedJson['posts'] as List;
    List<APIBLMHomeProfilePostExtended> familyMemorials = newList.map((i) => APIBLMHomeProfilePostExtended.fromJson(i)).toList();

    return APIBLMHomeProfilePostMain(
      blmItemsRemaining: parsedJson['itemsremaining'],
      blmFamilyMemorialList: familyMemorials,
    );
  }
}

class APIBLMHomeProfilePostExtended{
  int profilePostId;
  APIBLMHomeProfilePostExtendedPage profilePostPage;
  String profilePostBody;
  String profilePostLocation;
  double profilePostLatitude;
  double profilePostLongitude;
  List<dynamic> profilePostImagesOrVideos;
  List<APIBLMHomeProfilePostExtendedTagged> profilePostPostTagged;
  String profilePostCreateAt;
  int profilePostNumberOfLikes;
  int profilePostNumberOfComments;
  bool profilePostLikeStatus;

  APIBLMHomeProfilePostExtended({required this.profilePostId, required this.profilePostPage, required this.profilePostBody, required this.profilePostLocation, required this.profilePostLatitude, required this.profilePostLongitude, required this.profilePostImagesOrVideos, required this.profilePostPostTagged, required this.profilePostCreateAt, required this.profilePostNumberOfLikes, required this.profilePostNumberOfComments, required this.profilePostLikeStatus});

  factory APIBLMHomeProfilePostExtended.fromJson(Map<String, dynamic> parsedJson){
    
    List<dynamic>? newList1;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList1 = List<dynamic>.from(list);
    }

    var newList2 = parsedJson['tag_people'] as List;
    List<APIBLMHomeProfilePostExtendedTagged> taggedList = newList2.map((i) => APIBLMHomeProfilePostExtendedTagged.fromJson(i)).toList();
    
    return APIBLMHomeProfilePostExtended(
      profilePostId: parsedJson['id'],
      profilePostPage: APIBLMHomeProfilePostExtendedPage.fromJson(parsedJson['page']),
      profilePostBody: parsedJson['body'],
      profilePostLocation: parsedJson['location'],
      profilePostLatitude: parsedJson['latitude'],
      profilePostLongitude: parsedJson['longitude'],
      profilePostImagesOrVideos: newList1!,
      profilePostPostTagged: taggedList,
      profilePostCreateAt: parsedJson['created_at'],
      profilePostNumberOfLikes: parsedJson['numberOfLikes'],
      profilePostNumberOfComments: parsedJson['numberOfComments'],
      profilePostLikeStatus: parsedJson['likeStatus'],
    );
  }
}

class APIBLMHomeProfilePostExtendedPage{
  int profilePageId;
  String profilePageName;
  APIBLMHomeProfilePostExtendedPageDetails profilePageDetails;
  dynamic profilePageBackgroundImage;
  dynamic profilePageProfileImage;
  dynamic profilePageImagesOrVideos;
  String profilePageRelationship;
  APIBLMHomeProfilePostExtendedPageCreator profilePagePageCreator;
  bool profilePageManage;
  bool profilePageFamOrFriends;
  bool profilePageFollower;
  String profilePagePageType;
  String profilePagePrivacy;

  APIBLMHomeProfilePostExtendedPage({required this.profilePageId, required this.profilePageName, required this.profilePageDetails, required this.profilePageBackgroundImage, required this.profilePageProfileImage, required this.profilePageImagesOrVideos, required this.profilePageRelationship, required this.profilePagePageCreator, required this.profilePageManage, required this.profilePageFamOrFriends, required this.profilePageFollower, required this.profilePagePageType, required this.profilePagePrivacy});

  factory APIBLMHomeProfilePostExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeProfilePostExtendedPage(
      profilePageId: parsedJson['id'],
      profilePageName: parsedJson['name'],
      profilePageDetails: APIBLMHomeProfilePostExtendedPageDetails.fromJson(parsedJson['details']),
      profilePageBackgroundImage: parsedJson['backgroundImage'],
      profilePageProfileImage: parsedJson['profileImage'],
      profilePageImagesOrVideos: parsedJson['imagesOrVideos'],
      profilePageRelationship: parsedJson['relationship'],
      profilePagePageCreator: APIBLMHomeProfilePostExtendedPageCreator.fromJson(parsedJson['page_creator']),
      profilePageManage: parsedJson['manage'],
      profilePageFamOrFriends: parsedJson['famOrFriends'],
      profilePageFollower: parsedJson['follower'],
      profilePagePageType: parsedJson['page_type'],
      profilePagePrivacy: parsedJson['privacy'],
    );
  }
}

class APIBLMHomeProfilePostExtendedPageDetails{
  String profilePageDetailsDescription;
  String profilePageDetailsBirthPlace;
  String profilePageDetailsDob;
  String profilePageDetailsRip;
  String profilePageDetailsCemetery;
  String profilePageDetailsCountry;

  APIBLMHomeProfilePostExtendedPageDetails({required this.profilePageDetailsDescription, required this.profilePageDetailsBirthPlace, required this.profilePageDetailsDob, required this.profilePageDetailsRip, required this.profilePageDetailsCemetery, required this.profilePageDetailsCountry});

  factory APIBLMHomeProfilePostExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeProfilePostExtendedPageDetails(
      profilePageDetailsDescription: parsedJson['description'],
      profilePageDetailsBirthPlace: parsedJson['birthplace'],
      profilePageDetailsDob: parsedJson['dob'],
      profilePageDetailsRip: parsedJson['rip'],
      profilePageDetailsCemetery: parsedJson['cemetery'],
      profilePageDetailsCountry: parsedJson['country'],
    );
  }
}

class APIBLMHomeProfilePostExtendedPageCreator{
  int profilePageCreatorId;
  String profilePageCreatorFirstName;
  String profilePageCreatorLastName;
  String profilePageCreatorPhoneNumber;
  String profilePageCreatorEmail;
  String profilePageCreatorUserName;
  dynamic profilePageCreatorImage;

  APIBLMHomeProfilePostExtendedPageCreator({required this.profilePageCreatorId, required this.profilePageCreatorFirstName, required this.profilePageCreatorLastName, required this.profilePageCreatorPhoneNumber, required this.profilePageCreatorEmail, required this.profilePageCreatorUserName, required this.profilePageCreatorImage});

  factory APIBLMHomeProfilePostExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeProfilePostExtendedPageCreator(
      profilePageCreatorId: parsedJson['id'],
      profilePageCreatorFirstName: parsedJson['first_name'],
      profilePageCreatorLastName: parsedJson['last_name'],
      profilePageCreatorPhoneNumber: parsedJson['phone_number'],
      profilePageCreatorEmail: parsedJson['email'],
      profilePageCreatorUserName: parsedJson['username'],
      profilePageCreatorImage: parsedJson['image']
    );
  }
}

class APIBLMHomeProfilePostExtendedTagged{
  int profilePageTaggedId;
  String profilePageTaggedFirstName;
  String profilePageTaggedLastName;
  String profilePageTaggedImage;

  APIBLMHomeProfilePostExtendedTagged({required this.profilePageTaggedId, required this.profilePageTaggedFirstName, required this.profilePageTaggedLastName, required this.profilePageTaggedImage});

  factory APIBLMHomeProfilePostExtendedTagged.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeProfilePostExtendedTagged(
      profilePageTaggedId: parsedJson['id'],
      profilePageTaggedFirstName: parsedJson['first_name'],
      profilePageTaggedLastName: parsedJson['last_name'],
      profilePageTaggedImage: parsedJson['image']
    );
  }
}