import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularHomeTabPostMain> apiRegularHomePostTab({int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

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
    return APIRegularHomeTabPostMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the post');
  }
}

class APIRegularHomeTabPostMain{
  int almItemsRemaining;
  List<APIRegularHomeTabPostExtended> familyMemorialList;

  APIRegularHomeTabPostMain({this.almItemsRemaining, this.familyMemorialList});

  factory APIRegularHomeTabPostMain.fromJson(Map<String, dynamic> parsedJson){
    var newList = parsedJson['posts'] as List;
    List<APIRegularHomeTabPostExtended> familyMemorials = newList.map((i) => APIRegularHomeTabPostExtended.fromJson(i)).toList();

    return APIRegularHomeTabPostMain(
      almItemsRemaining: parsedJson['itemsremaining'],
      familyMemorialList: familyMemorials,
    );
  }
}

class APIRegularHomeTabPostExtended{
  int homeTabPostId;
  APIRegularHomeTabPostExtendedPage homeTabPostPage;
  String homeTabPostBody;
  String homeTabPostLocation;
  double homeTabPostLatitude;
  double homeTabPostLongitude;
  List<dynamic> homeTabPostImagesOrVideos;
  List<APIRegularHomeTabPostExtendedTagged> homeTabPostPostTagged;
  String homeTabPostCreateAt;
  int homeTabPostNumberOfLikes;
  int homeTabPostNumberOfComments;
  bool homeTabPostLikeStatus;

  APIRegularHomeTabPostExtended({this.homeTabPostId, this.homeTabPostPage, this.homeTabPostBody, this.homeTabPostLocation, this.homeTabPostLatitude, this.homeTabPostLongitude, this.homeTabPostImagesOrVideos, this.homeTabPostPostTagged, this.homeTabPostCreateAt, this.homeTabPostNumberOfLikes, this.homeTabPostNumberOfComments, this.homeTabPostLikeStatus});

  factory APIRegularHomeTabPostExtended.fromJson(Map<String, dynamic> parsedJson){
    
    List<dynamic> newList1;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList1 = List<dynamic>.from(list);
    }

    var newList2 = parsedJson['tag_people'] as List;
    List<APIRegularHomeTabPostExtendedTagged> taggedList = newList2.map((i) => APIRegularHomeTabPostExtendedTagged.fromJson(i)).toList();    
    
    return APIRegularHomeTabPostExtended(
      homeTabPostId: parsedJson['id'],
      homeTabPostPage: APIRegularHomeTabPostExtendedPage.fromJson(parsedJson['page']),
      homeTabPostBody: parsedJson['body'],
      homeTabPostLocation: parsedJson['location'],
      homeTabPostLatitude: parsedJson['latitude'],
      homeTabPostLongitude: parsedJson['longitude'],
      homeTabPostImagesOrVideos: newList1,
      homeTabPostPostTagged: taggedList,
      homeTabPostCreateAt: parsedJson['created_at'],
      homeTabPostNumberOfLikes: parsedJson['numberOfLikes'],
      homeTabPostNumberOfComments: parsedJson['numberOfComments'],
      homeTabPostLikeStatus: parsedJson['likeStatus'],
    );
  }
}

class APIRegularHomeTabPostExtendedPage{
  int homeTabPostPageId;
  String homeTabPostPageName;
  APIRegularHomeTabPostExtendedPageDetails homeTabPostPageDetails;
  dynamic homeTabPostPageBackgroundImage;
  dynamic homeTabPostPageProfileImage;
  dynamic homeTabPostPageImagesOrVideos;
  String homeTabPostPageRelationship;
  APIRegularHomeTabPostExtendedPageCreator homeTabPostPagePageCreator;
  bool homeTabPostPageManage;
  bool homeTabPostPageFamOrFriends;
  bool homeTabPostPageFollower;
  String homeTabPostPagePageType;
  String homeTabPostPagePrivacy;

  APIRegularHomeTabPostExtendedPage({this.homeTabPostPageId, this.homeTabPostPageName, this.homeTabPostPageDetails, this.homeTabPostPageBackgroundImage, this.homeTabPostPageProfileImage, this.homeTabPostPageImagesOrVideos, this.homeTabPostPageRelationship, this.homeTabPostPagePageCreator, this.homeTabPostPageManage, this.homeTabPostPageFamOrFriends, this.homeTabPostPageFollower, this.homeTabPostPagePageType, this.homeTabPostPagePrivacy});

  factory APIRegularHomeTabPostExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeTabPostExtendedPage(
      homeTabPostPageId: parsedJson['id'],
      homeTabPostPageName: parsedJson['name'],
      homeTabPostPageDetails: APIRegularHomeTabPostExtendedPageDetails.fromJson(parsedJson['details']),
      homeTabPostPageBackgroundImage: parsedJson['backgroundImage'],
      homeTabPostPageProfileImage: parsedJson['profileImage'],
      homeTabPostPageImagesOrVideos: parsedJson['imagesOrVideos'],
      homeTabPostPageRelationship: parsedJson['relationship'],
      homeTabPostPagePageCreator: APIRegularHomeTabPostExtendedPageCreator.fromJson(parsedJson['page_creator']),
      homeTabPostPageManage: parsedJson['manage'],
      homeTabPostPageFamOrFriends: parsedJson['famOrFriends'],
      homeTabPostPageFollower: parsedJson['follower'],
      homeTabPostPagePageType: parsedJson['page_type'],
      homeTabPostPagePrivacy: parsedJson['privacy'],
    );
  }
}

class APIRegularHomeTabPostExtendedPageDetails{
  String homeTabPostPageDetailsDescription;
  String homeTabPostPageDetailsBirthPlace;
  String homeTabPostPageDetailsDob;
  String homeTabPostPageDetailsRip;
  String homeTabPostPageDetailsCemetery;
  String homeTabPostPageDetailsCountry;

  APIRegularHomeTabPostExtendedPageDetails({this.homeTabPostPageDetailsDescription, this.homeTabPostPageDetailsBirthPlace, this.homeTabPostPageDetailsDob, this.homeTabPostPageDetailsRip, this.homeTabPostPageDetailsCemetery, this.homeTabPostPageDetailsCountry});

  factory APIRegularHomeTabPostExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeTabPostExtendedPageDetails(
      homeTabPostPageDetailsDescription: parsedJson['description'],
      homeTabPostPageDetailsBirthPlace: parsedJson['birthplace'],
      homeTabPostPageDetailsDob: parsedJson['dob'],
      homeTabPostPageDetailsRip: parsedJson['rip'],
      homeTabPostPageDetailsCemetery: parsedJson['cemetery'],
      homeTabPostPageDetailsCountry: parsedJson['country'],
    );
  }
}

class APIRegularHomeTabPostExtendedPageCreator{
  int homeTabPostPageCreatorId;
  String homeTabPostPageCreatorFirstName;
  String homeTabPostPageCreatorLastName;
  String homeTabPostPageCreatorPhoneNumber;
  String homeTabPostPageCreatorEmail;
  String homeTabPostPageCreatorUserName;
  dynamic homeTabPostPageCreatorImage;

  APIRegularHomeTabPostExtendedPageCreator({this.homeTabPostPageCreatorId, this.homeTabPostPageCreatorFirstName, this.homeTabPostPageCreatorLastName, this.homeTabPostPageCreatorPhoneNumber, this.homeTabPostPageCreatorEmail, this.homeTabPostPageCreatorUserName, this.homeTabPostPageCreatorImage});

  factory APIRegularHomeTabPostExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeTabPostExtendedPageCreator(
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

class APIRegularHomeTabPostExtendedTagged{
  int homeTabPostTabTaggedId;
  String homeTabPostTabTaggedFirstName;
  String homeTabPostTabTaggedLastName;
  String homeTabPostTabTaggedImage;

  APIRegularHomeTabPostExtendedTagged({this.homeTabPostTabTaggedId, this.homeTabPostTabTaggedFirstName, this.homeTabPostTabTaggedLastName, this.homeTabPostTabTaggedImage});

  factory APIRegularHomeTabPostExtendedTagged.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeTabPostExtendedTagged(
      homeTabPostTabTaggedId: parsedJson['id'],
      homeTabPostTabTaggedFirstName: parsedJson['first_name'],
      homeTabPostTabTaggedLastName: parsedJson['last_name'],
      homeTabPostTabTaggedImage: parsedJson['image']
    );
  }
}