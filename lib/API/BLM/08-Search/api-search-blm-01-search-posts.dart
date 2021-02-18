import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMSearchPostMain> apiBLMSearchPosts({String keywords, int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/search/posts?page=$page&keywords=$keywords',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The status code of posts in blm is ${response.statusCode}');
  print('The status body of posts in blm is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMSearchPostMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the feed');
  }
}

class APIBLMSearchPostMain{
  int blmItemsRemaining;
  List<APIBLMSearchPostExtended> blmSearchPostList;

  APIBLMSearchPostMain({this.blmItemsRemaining, this.blmSearchPostList});

  factory APIBLMSearchPostMain.fromJson(Map<String, dynamic> parsedJson){
    var newList = parsedJson['posts'] as List;
    List<APIBLMSearchPostExtended> familyMemorials = newList.map((i) => APIBLMSearchPostExtended.fromJson(i)).toList();

    return APIBLMSearchPostMain(
      blmItemsRemaining: parsedJson['itemsremaining'],
      blmSearchPostList: familyMemorials,
    );
  }
}

class APIBLMSearchPostExtended{
  int searchPostPostId;
  APIBLMSearchPostExtendedPage searchPostPage;
  String searchPostBody;
  String searchPostLocation;
  double searchPostLatitude;
  double searchPostLongitude;
  List<dynamic> searchPostImagesOrVideos;
  List<APIBLMSearchPostExtendedTagged> searchPostPostTagged;
  String searchPostCreateAt;
  int searchPostNumberOfLikes;
  int searchPostNumberOfComments;
  bool searchPostLikeStatus;

  APIBLMSearchPostExtended({this.searchPostPostId, this.searchPostPage, this.searchPostBody, this.searchPostLocation, this.searchPostLatitude, this.searchPostLongitude, this.searchPostImagesOrVideos, this.searchPostPostTagged, this.searchPostCreateAt, this.searchPostNumberOfLikes, this.searchPostNumberOfComments, this.searchPostLikeStatus});

  factory APIBLMSearchPostExtended.fromJson(Map<String, dynamic> parsedJson){
    
    List<dynamic> newList;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList = List<dynamic>.from(list);
    }

    var newList2 = parsedJson['tag_people'] as List;
    List<APIBLMSearchPostExtendedTagged> taggedList = newList2.map((i) => APIBLMSearchPostExtendedTagged.fromJson(i)).toList();
    
    return APIBLMSearchPostExtended(
      searchPostPostId: parsedJson['id'],
      searchPostPage: APIBLMSearchPostExtendedPage.fromJson(parsedJson['page']),
      searchPostBody: parsedJson['body'],
      searchPostLocation: parsedJson['location'],
      searchPostLatitude: parsedJson['latitude'],
      searchPostLongitude: parsedJson['longitude'],
      searchPostImagesOrVideos: newList,
      searchPostPostTagged: taggedList,
      searchPostCreateAt: parsedJson['created_at'],
      searchPostNumberOfLikes: parsedJson['numberOfLikes'],
      searchPostNumberOfComments: parsedJson['numberOfComments'],
      searchPostLikeStatus: parsedJson['likeStatus'],
    );
  }
}

class APIBLMSearchPostExtendedPage{
  int searchPostPagePageId;
  String searchPostPageName;
  APIBLMSearchPostExtendedPageDetails searchPostPageDetails;
  dynamic searchPostPageBackgroundImage;
  dynamic searchPostPageProfileImage;
  dynamic searchPostPageImagesOrVideos;
  String searchPostPageRelationship;
  APIBLMSearchPostExtendedPageCreator searchPostPagePageCreator;
  bool searchPostPageManage;
  bool searchPostPageFamOrFriends;
  bool searchPostPageFollower;
  String searchPostPagePageType;
  String searchPostPagePrivacy;

  APIBLMSearchPostExtendedPage({this.searchPostPagePageId, this.searchPostPageName, this.searchPostPageDetails, this.searchPostPageBackgroundImage, this.searchPostPageProfileImage, this.searchPostPageImagesOrVideos, this.searchPostPageRelationship, this.searchPostPagePageCreator, this.searchPostPageManage, this.searchPostPageFamOrFriends, this.searchPostPageFollower, this.searchPostPagePageType, this.searchPostPagePrivacy});

  factory APIBLMSearchPostExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMSearchPostExtendedPage(
      searchPostPagePageId: parsedJson['id'],
      searchPostPageName: parsedJson['name'],
      searchPostPageDetails: APIBLMSearchPostExtendedPageDetails.fromJson(parsedJson['details']),
      searchPostPageBackgroundImage: parsedJson['backgroundImage'],
      searchPostPageProfileImage: parsedJson['profileImage'],
      searchPostPageImagesOrVideos: parsedJson['imagesOrVideos'],
      searchPostPageRelationship: parsedJson['relationship'],
      searchPostPagePageCreator: APIBLMSearchPostExtendedPageCreator.fromJson(parsedJson['page_creator']),
      searchPostPageManage: parsedJson['manage'],
      searchPostPageFamOrFriends: parsedJson['famOrFriends'],
      searchPostPageFollower: parsedJson['follower'],
      searchPostPagePageType: parsedJson['page_type'],
      searchPostPagePrivacy: parsedJson['privacy'],
    );
  }
}

class APIBLMSearchPostExtendedPageDetails{
  String searchPostPageDetailsDescription;
  String searchPostPageDetailsBirthPlace;
  String searchPostPageDetailsDob;
  String searchPostPageDetailsRip;
  String searchPostPageDetailsCemetery;
  String searchPostPageDetailsCountry;

  APIBLMSearchPostExtendedPageDetails({this.searchPostPageDetailsDescription, this.searchPostPageDetailsBirthPlace, this.searchPostPageDetailsDob, this.searchPostPageDetailsRip, this.searchPostPageDetailsCemetery, this.searchPostPageDetailsCountry});

  factory APIBLMSearchPostExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMSearchPostExtendedPageDetails(
      searchPostPageDetailsDescription: parsedJson['description'],
      searchPostPageDetailsBirthPlace: parsedJson['birthplace'],
      searchPostPageDetailsDob: parsedJson['dob'],
      searchPostPageDetailsRip: parsedJson['rip'],
      searchPostPageDetailsCemetery: parsedJson['cemetery'],
      searchPostPageDetailsCountry: parsedJson['country'],
    );
  }
}

class APIBLMSearchPostExtendedPageCreator{
  int searchPostPageCreatorCreatorId;
  String searchPostPageCreatorFirstName;
  String searchPostPageCreatorLastName;
  String searchPostPageCreatorPhoneNumber;
  String searchPostPageCreatorEmail;
  String searchPostPageCreatorUserName;
  dynamic searchPostPageCreatorImage;

  APIBLMSearchPostExtendedPageCreator({this.searchPostPageCreatorCreatorId, this.searchPostPageCreatorFirstName, this.searchPostPageCreatorLastName, this.searchPostPageCreatorPhoneNumber, this.searchPostPageCreatorEmail, this.searchPostPageCreatorUserName, this.searchPostPageCreatorImage});

  factory APIBLMSearchPostExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMSearchPostExtendedPageCreator(
      searchPostPageCreatorCreatorId: parsedJson['id'],
      searchPostPageCreatorFirstName: parsedJson['first_name'],
      searchPostPageCreatorLastName: parsedJson['last_name'],
      searchPostPageCreatorPhoneNumber: parsedJson['phone_number'],
      searchPostPageCreatorEmail: parsedJson['email'],
      searchPostPageCreatorUserName: parsedJson['username'],
      searchPostPageCreatorImage: parsedJson['image']
    );
  }
}

class APIBLMSearchPostExtendedTagged{
  int searchPostTaggedId;
  String searchPostTaggedFirstName;
  String searchPostTaggedLastName;
  String searchPostTaggedImage;

  APIBLMSearchPostExtendedTagged({this.searchPostTaggedId, this.searchPostTaggedFirstName, this.searchPostTaggedLastName, this.searchPostTaggedImage});

  factory APIBLMSearchPostExtendedTagged.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMSearchPostExtendedTagged(
      searchPostTaggedId: parsedJson['id'],
      searchPostTaggedFirstName: parsedJson['first_name'],
      searchPostTaggedLastName: parsedJson['last_name'],
      searchPostTaggedImage: parsedJson['image']
    );
  }
}