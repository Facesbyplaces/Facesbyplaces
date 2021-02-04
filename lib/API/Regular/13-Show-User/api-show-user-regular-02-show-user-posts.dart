import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowUsersPostsMain> apiRegularShowUserPosts({int userId, int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/users/posts?user_id=$userId&page=$page',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularShowUsersPostsMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the post');
  }
}

class APIRegularShowUsersPostsMain{
  int almItemsRemaining;
  List<APIRegularShowUsersPostsExtended> almFamilyMemorialList;

  APIRegularShowUsersPostsMain({this.almItemsRemaining, this.almFamilyMemorialList});

  factory APIRegularShowUsersPostsMain.fromJson(Map<String, dynamic> parsedJson){
    var newList = parsedJson['posts'] as List;
    List<APIRegularShowUsersPostsExtended> familyMemorials = newList.map((i) => APIRegularShowUsersPostsExtended.fromJson(i)).toList();

    return APIRegularShowUsersPostsMain(
      almItemsRemaining: parsedJson['itemsremaining'],
      almFamilyMemorialList: familyMemorials,
    );
  }
}

class APIRegularShowUsersPostsExtended{
  int showUsersPostsId;
  APIRegularShowUsersPostsExtendedPage showUsersPostsPage;
  String showUsersPostsBody;
  String showUsersPostsLocation;
  double showUsersPostsLatitude;
  double showUsersPostsLongitude;
  List<dynamic> showUsersPostsImagesOrVideos;
  List<APIRegularShowUsersPostsExtendedTagged> showUsersPostsPostTagged;
  String showUsersPostsCreatedAt;
  int showUsersPostsNumberOfLikes;
  int showUsersPostsNumberOfComments;
  bool showUsersPostsLikeStatus;

  APIRegularShowUsersPostsExtended({this.showUsersPostsId, this.showUsersPostsPage, this.showUsersPostsBody, this.showUsersPostsLocation, this.showUsersPostsLatitude, this.showUsersPostsLongitude, this.showUsersPostsImagesOrVideos, this.showUsersPostsPostTagged, this.showUsersPostsCreatedAt, this.showUsersPostsNumberOfLikes, this.showUsersPostsNumberOfComments, this.showUsersPostsLikeStatus});

  factory APIRegularShowUsersPostsExtended.fromJson(Map<String, dynamic> parsedJson){
    
    List<dynamic> newList1;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList1 = List<dynamic>.from(list);
    }

    var newList2 = parsedJson['tag_people'] as List;
    List<APIRegularShowUsersPostsExtendedTagged> taggedList = newList2.map((i) => APIRegularShowUsersPostsExtendedTagged.fromJson(i)).toList();
    
    return APIRegularShowUsersPostsExtended(
      showUsersPostsId: parsedJson['id'],
      showUsersPostsPage: APIRegularShowUsersPostsExtendedPage.fromJson(parsedJson['page']),
      showUsersPostsBody: parsedJson['body'],
      showUsersPostsLocation: parsedJson['location'],
      showUsersPostsLatitude: parsedJson['latitude'],
      showUsersPostsLongitude: parsedJson['longitude'],
      showUsersPostsImagesOrVideos: newList1,
      showUsersPostsPostTagged: taggedList,
      showUsersPostsCreatedAt: parsedJson['created_at'],
      showUsersPostsNumberOfLikes: parsedJson['numberOfLikes'],
      showUsersPostsNumberOfComments: parsedJson['numberOfComments'],
      showUsersPostsLikeStatus: parsedJson['likeStatus'],
    );
  }
}

class APIRegularShowUsersPostsExtendedPage{
  int showUsersPostsPageId;
  String showUsersPostsPageName;
  APIRegularShowUsersPostsExtendedPageDetails showUsersPostsPageDetails;
  dynamic showUsersPostsPageBackgroundImage;
  dynamic showUsersPostsPageProfileImage;
  dynamic showUsersPostsPageImagesOrVideos;
  String showUsersPostsPageRelationship;
  APIRegularShowUsersPostsExtendedPageCreator showUsersPostsPagePageCreator;
  bool showUsersPostsPageFollower;
  bool showUsersPostsPageManage;
  String showUsersPostsPagePageType;
  String showUsersPostsPagePrivacy;

  APIRegularShowUsersPostsExtendedPage({this.showUsersPostsPageId, this.showUsersPostsPageName, this.showUsersPostsPageDetails, this.showUsersPostsPageBackgroundImage, this.showUsersPostsPageProfileImage, this.showUsersPostsPageImagesOrVideos, this.showUsersPostsPageRelationship, this.showUsersPostsPagePageCreator, this.showUsersPostsPageFollower, this.showUsersPostsPageManage, this.showUsersPostsPagePageType, this.showUsersPostsPagePrivacy});

  factory APIRegularShowUsersPostsExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowUsersPostsExtendedPage(
      showUsersPostsPageId: parsedJson['id'],
      showUsersPostsPageName: parsedJson['name'],
      showUsersPostsPageDetails: APIRegularShowUsersPostsExtendedPageDetails.fromJson(parsedJson['details']),
      showUsersPostsPageBackgroundImage: parsedJson['backgroundImage'],
      showUsersPostsPageProfileImage: parsedJson['profileImage'],
      showUsersPostsPageImagesOrVideos: parsedJson['imagesOrVideos'],
      showUsersPostsPageRelationship: parsedJson['relationship'],
      showUsersPostsPagePageCreator: APIRegularShowUsersPostsExtendedPageCreator.fromJson(parsedJson['page_creator']),
      showUsersPostsPageFollower: parsedJson['follower'],
      showUsersPostsPageManage: parsedJson['manage'],
      showUsersPostsPagePageType: parsedJson['page_type'],
      showUsersPostsPagePrivacy: parsedJson['privacy'],
    );
  }
}

class APIRegularShowUsersPostsExtendedPageDetails{
  String showUsersPostsPageDetailsDescription;
  String showUsersPostsPageDetailsBirthPlace;
  String showUsersPostsPageDetailsDob;
  String showUsersPostsPageDetailsRip;
  String showUsersPostsPageDetailsCemetery;
  String showUsersPostsPageDetailsCountry;

  APIRegularShowUsersPostsExtendedPageDetails({this.showUsersPostsPageDetailsDescription, this.showUsersPostsPageDetailsBirthPlace, this.showUsersPostsPageDetailsDob, this.showUsersPostsPageDetailsRip, this.showUsersPostsPageDetailsCemetery, this.showUsersPostsPageDetailsCountry});

  factory APIRegularShowUsersPostsExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowUsersPostsExtendedPageDetails(
      showUsersPostsPageDetailsDescription: parsedJson['description'],
      showUsersPostsPageDetailsBirthPlace: parsedJson['birthplace'],
      showUsersPostsPageDetailsDob: parsedJson['dob'],
      showUsersPostsPageDetailsRip: parsedJson['rip'],
      showUsersPostsPageDetailsCemetery: parsedJson['cemetery'],
      showUsersPostsPageDetailsCountry: parsedJson['country'],
    );
  }
}

class APIRegularShowUsersPostsExtendedPageCreator{
  int showUsersPostsPageCreatorId;
  String showUsersPostsPageCreatorFirstName;
  String showUsersPostsPageCreatorLastName;
  String showUsersPostsPageCreatorPhoneNumber;
  String showUsersPostsPageCreatorEmail;
  String showUsersPostsPageCreatorUserName;
  dynamic showUsersPostsPageCreatorImage;

  APIRegularShowUsersPostsExtendedPageCreator({this.showUsersPostsPageCreatorId, this.showUsersPostsPageCreatorFirstName, this.showUsersPostsPageCreatorLastName, this.showUsersPostsPageCreatorPhoneNumber, this.showUsersPostsPageCreatorEmail, this.showUsersPostsPageCreatorUserName, this.showUsersPostsPageCreatorImage});

  factory APIRegularShowUsersPostsExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowUsersPostsExtendedPageCreator(
      showUsersPostsPageCreatorId: parsedJson['id'],
      showUsersPostsPageCreatorFirstName: parsedJson['first_name'],
      showUsersPostsPageCreatorLastName: parsedJson['last_name'],
      showUsersPostsPageCreatorPhoneNumber: parsedJson['phone_number'],
      showUsersPostsPageCreatorEmail: parsedJson['email'],
      showUsersPostsPageCreatorUserName: parsedJson['username'],
      showUsersPostsPageCreatorImage: parsedJson['image']
    );
  }
}

class APIRegularShowUsersPostsExtendedTagged{
  int showUsersPostsTaggedId;
  String showUsersPostsTaggedFirstName;
  String showUsersPostsTaggedLastName;
  String showUsersPostsTaggedImage;

  APIRegularShowUsersPostsExtendedTagged({this.showUsersPostsTaggedId, this.showUsersPostsTaggedFirstName, this.showUsersPostsTaggedLastName, this.showUsersPostsTaggedImage});

  factory APIRegularShowUsersPostsExtendedTagged.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowUsersPostsExtendedTagged(
      showUsersPostsTaggedId: parsedJson['id'],
      showUsersPostsTaggedFirstName: parsedJson['first_name'],
      showUsersPostsTaggedLastName: parsedJson['last_name'],
      showUsersPostsTaggedImage: parsedJson['image']
    );
  }
}