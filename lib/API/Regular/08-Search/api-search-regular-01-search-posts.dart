import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularSearchPostMain> apiRegularSearchPosts({String keywords, int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/search/posts?page=$page&keywords=$keywords',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The status code of posts in alm is ${response.statusCode}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularSearchPostMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the posts.');
  }
}

class APIRegularSearchPostMain{
  int almItemsRemaining;
  List<APIRegularSearchPostExtended> almSearchPostList;

  APIRegularSearchPostMain({this.almItemsRemaining, this.almSearchPostList});

  factory APIRegularSearchPostMain.fromJson(Map<String, dynamic> parsedJson){
    var newList = parsedJson['posts'] as List;
    List<APIRegularSearchPostExtended> searchPostList = newList.map((i) => APIRegularSearchPostExtended.fromJson(i)).toList();

    return APIRegularSearchPostMain(
      almItemsRemaining: parsedJson['itemsremaining'],
      almSearchPostList: searchPostList,
    );
  }
}

class APIRegularSearchPostExtended{
  int searchPostId;
  APIRegularSearchPostExtendedPage searchPostPage;
  String searchPostBody;
  String searchPostLocation;
  double searchPostLatitude;
  double searchPostLongitude;
  List<dynamic> searchPostImagesOrVideos;
  List<APIRegularSearchPostExtendedTagged> searchPostPostTagged;
  List<dynamic> searchPostTagPeople;
  String searchPostCreateAt;
  int searchPostNumberOfLikes;
  int searchPostNumberOfComments;
  bool searchPostLikeStatus;

  APIRegularSearchPostExtended({this.searchPostId, this.searchPostPage, this.searchPostBody, this.searchPostLocation, this.searchPostLatitude, this.searchPostLongitude, this.searchPostImagesOrVideos, this.searchPostPostTagged, this.searchPostTagPeople, this.searchPostCreateAt, this.searchPostNumberOfLikes, this.searchPostNumberOfComments, this.searchPostLikeStatus});

  factory APIRegularSearchPostExtended.fromJson(Map<String, dynamic> parsedJson){
    
    List<dynamic> newList1;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList1 = List<dynamic>.from(list);
    }

    var newList2 = parsedJson['tag_people'] as List;
    List<APIRegularSearchPostExtendedTagged> taggedList = newList2.map((i) => APIRegularSearchPostExtendedTagged.fromJson(i)).toList();
    
    return APIRegularSearchPostExtended(
      searchPostId: parsedJson['id'],
      searchPostPage: APIRegularSearchPostExtendedPage.fromJson(parsedJson['page']),
      searchPostBody: parsedJson['body'],
      searchPostLocation: parsedJson['location'],
      searchPostLatitude: parsedJson['latitude'],
      searchPostLongitude: parsedJson['longitude'],
      searchPostImagesOrVideos: newList1,
      searchPostPostTagged: taggedList,
      searchPostCreateAt: parsedJson['created_at'],
      searchPostNumberOfLikes: parsedJson['numberOfLikes'],
      searchPostNumberOfComments: parsedJson['numberOfComments'],
      searchPostLikeStatus: parsedJson['likeStatus'],
    );
  }
}

class APIRegularSearchPostExtendedPage{
  int searchPostPageId;
  String searchPostPageName;
  APIRegularSearchPostExtendedPageDetails searchPostPageDetails;
  dynamic searchPostPageBackgroundImage;
  dynamic searchPostPageProfileImage;
  dynamic searchPostPageImagesOrVideos;
  String searchPostPageRelationship;
  APIRegularSearchPostExtendedPageCreator searchPostPagePageCreator;
  bool searchPostPageManage;
  bool searchPostPageFamOrFriends;
  bool searchPostPageFollower;
  String searchPostPagePageType;
  String searchPostPagePrivacy;

  APIRegularSearchPostExtendedPage({this.searchPostPageId, this.searchPostPageName, this.searchPostPageDetails, this.searchPostPageBackgroundImage, this.searchPostPageProfileImage, this.searchPostPageImagesOrVideos, this.searchPostPageRelationship, this.searchPostPagePageCreator, this.searchPostPageManage, this.searchPostPageFamOrFriends, this.searchPostPageFollower, this.searchPostPagePageType, this.searchPostPagePrivacy});

  factory APIRegularSearchPostExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularSearchPostExtendedPage(
      searchPostPageId: parsedJson['id'],
      searchPostPageName: parsedJson['name'],
      searchPostPageDetails: APIRegularSearchPostExtendedPageDetails.fromJson(parsedJson['details']),
      searchPostPageBackgroundImage: parsedJson['backgroundImage'],
      searchPostPageProfileImage: parsedJson['profileImage'],
      searchPostPageImagesOrVideos: parsedJson['imagesOrVideos'],
      searchPostPageRelationship: parsedJson['relationship'],
      searchPostPagePageCreator: APIRegularSearchPostExtendedPageCreator.fromJson(parsedJson['page_creator']),
      searchPostPageManage: parsedJson['manage'],
      searchPostPageFamOrFriends: parsedJson['famOrFriends'],
      searchPostPageFollower: parsedJson['follower'],
      searchPostPagePageType: parsedJson['page_type'],
      searchPostPagePrivacy: parsedJson['privacy'],
    );
  }
}

class APIRegularSearchPostExtendedPageDetails{
  String searchPostPageDetailsDescription;
  String searchPostPageDetailsBirthPlace;
  String searchPostPageDetailsDob;
  String searchPostPageDetailsRip;
  String searchPostPageDetailsCemetery;
  String searchPostPageDetailsCountry;

  APIRegularSearchPostExtendedPageDetails({this.searchPostPageDetailsDescription, this.searchPostPageDetailsBirthPlace, this.searchPostPageDetailsDob, this.searchPostPageDetailsRip, this.searchPostPageDetailsCemetery, this.searchPostPageDetailsCountry});

  factory APIRegularSearchPostExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularSearchPostExtendedPageDetails(
      searchPostPageDetailsDescription: parsedJson['description'],
      searchPostPageDetailsBirthPlace: parsedJson['birthplace'],
      searchPostPageDetailsDob: parsedJson['dob'],
      searchPostPageDetailsRip: parsedJson['rip'],
      searchPostPageDetailsCemetery: parsedJson['cemetery'],
      searchPostPageDetailsCountry: parsedJson['country'],
    );
  }
}

class APIRegularSearchPostExtendedPageCreator{
  int searchPostPageCreatorId;
  String searchPostPageCreatorFirstName;
  String searchPostPageCreatorLastName;
  String searchPostPageCreatorPhoneNumber;
  String searchPostPageCreatorEmail;
  String searchPostPageCreatorUserName;
  dynamic searchPostPageCreatorImage;

  APIRegularSearchPostExtendedPageCreator({this.searchPostPageCreatorId, this.searchPostPageCreatorFirstName, this.searchPostPageCreatorLastName, this.searchPostPageCreatorPhoneNumber, this.searchPostPageCreatorEmail, this.searchPostPageCreatorUserName, this.searchPostPageCreatorImage});

  factory APIRegularSearchPostExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularSearchPostExtendedPageCreator(
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

class APIRegularSearchPostExtendedTagged{
  int searchPostTaggedId;
  String searchPostTaggedFirstName;
  String searchPostTaggedLastName;
  String searchPostTaggedImage;

  APIRegularSearchPostExtendedTagged({this.searchPostTaggedId, this.searchPostTaggedFirstName, this.searchPostTaggedLastName, this.searchPostTaggedImage});

  factory APIRegularSearchPostExtendedTagged.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularSearchPostExtendedTagged(
      searchPostTaggedId: parsedJson['id'],
      searchPostTaggedFirstName: parsedJson['first_name'],
      searchPostTaggedLastName: parsedJson['last_name'],
      searchPostTaggedImage: parsedJson['image']
    );
  }
}