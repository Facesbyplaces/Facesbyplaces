import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularHomeProfilePostMain> apiRegularProfilePost({int memorialId, int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/posts/page/Memorial/$memorialId?page=$page',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularHomeProfilePostMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the post');
  }
}


class APIRegularHomeProfilePostMain{
  int almItemsRemaining;
  List<APIRegularHomeProfilePostExtended> almFamilyMemorialList;

  APIRegularHomeProfilePostMain({this.almItemsRemaining, this.almFamilyMemorialList});

  factory APIRegularHomeProfilePostMain.fromJson(Map<String, dynamic> parsedJson){
    var newList = parsedJson['posts'] as List;
    List<APIRegularHomeProfilePostExtended> familyMemorials = newList.map((i) => APIRegularHomeProfilePostExtended.fromJson(i)).toList();

    return APIRegularHomeProfilePostMain(
      almItemsRemaining: parsedJson['itemsremaining'],
      almFamilyMemorialList: familyMemorials,
    );
  }
}


class APIRegularHomeProfilePostExtended{
  int homeProfilePostId;
  APIRegularHomeProfilePostExtendedPage homeProfilePostPage;
  String homeProfilePostBody;
  String homeProfilePostLocation;
  double homeProfilePostLatitude;
  double homeProfilePostLongitude;
  List<dynamic> homeProfilePostImagesOrVideos;
  List<APIRegularHomeProfilePostExtendedTagged> homeProfilePostTagged;
  String homeProfilePostCreatedAt;
  int homeProfilePostNumberOfLikes;
  int homeProfilePostNumberOfComments;
  bool homeProfilePostLikeStatus;

  APIRegularHomeProfilePostExtended({this.homeProfilePostId, this.homeProfilePostPage, this.homeProfilePostBody, this.homeProfilePostLocation, this.homeProfilePostLatitude, this.homeProfilePostLongitude, this.homeProfilePostImagesOrVideos, this.homeProfilePostTagged, this.homeProfilePostCreatedAt, this.homeProfilePostNumberOfLikes, this.homeProfilePostNumberOfComments, this.homeProfilePostLikeStatus});

  factory APIRegularHomeProfilePostExtended.fromJson(Map<String, dynamic> parsedJson){
    
    List<dynamic> newList1;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList1 = List<dynamic>.from(list);
    }

    var newList2 = parsedJson['tag_people'] as List;
    List<APIRegularHomeProfilePostExtendedTagged> taggedList = newList2.map((i) => APIRegularHomeProfilePostExtendedTagged.fromJson(i)).toList();
    
    return APIRegularHomeProfilePostExtended(
      homeProfilePostId: parsedJson['id'],
      homeProfilePostPage: APIRegularHomeProfilePostExtendedPage.fromJson(parsedJson['page']),
      homeProfilePostBody: parsedJson['body'],
      homeProfilePostLocation: parsedJson['location'],
      homeProfilePostLatitude: parsedJson['latitude'],
      homeProfilePostLongitude: parsedJson['longitude'],
      homeProfilePostImagesOrVideos: newList1,
      homeProfilePostTagged: taggedList,
      homeProfilePostCreatedAt: parsedJson['created_at'],
      homeProfilePostNumberOfLikes: parsedJson['numberOfLikes'],
      homeProfilePostNumberOfComments: parsedJson['numberOfComments'],
      homeProfilePostLikeStatus: parsedJson['likeStatus'],
    );
  }
}

class APIRegularHomeProfilePostExtendedPage{
  int homeProfilePostPageId;
  String homeProfilePostPageName;
  APIRegularHomeProfilePostExtendedPageDetails homeProfilePostPageDetails;
  dynamic homeProfilePostPageBackgroundImage;
  dynamic homeProfilePostPageProfileImage;
  dynamic homeProfilePostPageImagesOrVideos;
  String homeProfilePostPageRelationship;
  APIRegularHomeProfilePostExtendedPageCreator homeProfilePostPagePageCreator;
  bool homeProfilePostPageManage;
  bool homeProfilePostPageFamOrFriends;
  bool homeProfilePostPageFollower;
  String homeProfilePostPagePageType;
  String homeProfilePostPagePrivacy;

  APIRegularHomeProfilePostExtendedPage({this.homeProfilePostPageId, this.homeProfilePostPageName, this.homeProfilePostPageDetails, this.homeProfilePostPageBackgroundImage, this.homeProfilePostPageProfileImage, this.homeProfilePostPageImagesOrVideos, this.homeProfilePostPageRelationship, this.homeProfilePostPagePageCreator, this.homeProfilePostPageManage, this.homeProfilePostPageFamOrFriends, this.homeProfilePostPageFollower, this.homeProfilePostPagePageType, this.homeProfilePostPagePrivacy});

  factory APIRegularHomeProfilePostExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeProfilePostExtendedPage(
      homeProfilePostPageId: parsedJson['id'],
      homeProfilePostPageName: parsedJson['name'],
      homeProfilePostPageDetails: APIRegularHomeProfilePostExtendedPageDetails.fromJson(parsedJson['details']),
      homeProfilePostPageBackgroundImage: parsedJson['backgroundImage'],
      homeProfilePostPageProfileImage: parsedJson['profileImage'],
      homeProfilePostPageImagesOrVideos: parsedJson['imagesOrVideos'],
      homeProfilePostPageRelationship: parsedJson['relationship'],
      homeProfilePostPagePageCreator: APIRegularHomeProfilePostExtendedPageCreator.fromJson(parsedJson['page_creator']),
      homeProfilePostPageManage: parsedJson['manage'],
      homeProfilePostPageFamOrFriends: parsedJson['famOrFriends'],
      homeProfilePostPageFollower: parsedJson['follower'],
      homeProfilePostPagePageType: parsedJson['page_type'],
      homeProfilePostPagePrivacy: parsedJson['privacy'],
    );
  }
}

class APIRegularHomeProfilePostExtendedPageDetails{
  String homeProfilePostPageDetailsDescription;
  String homeProfilePostPageDetailsBirthPlace;
  String homeProfilePostPageDetailsDob;
  String homeProfilePostPageDetailsRip;
  String homeProfilePostPageDetailsCemetery;
  String homeProfilePostPageDetailsCountry;

  APIRegularHomeProfilePostExtendedPageDetails({this.homeProfilePostPageDetailsDescription, this.homeProfilePostPageDetailsBirthPlace, this.homeProfilePostPageDetailsDob, this.homeProfilePostPageDetailsRip, this.homeProfilePostPageDetailsCemetery, this.homeProfilePostPageDetailsCountry});

  factory APIRegularHomeProfilePostExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeProfilePostExtendedPageDetails(
      homeProfilePostPageDetailsDescription: parsedJson['description'],
      homeProfilePostPageDetailsBirthPlace: parsedJson['birthplace'],
      homeProfilePostPageDetailsDob: parsedJson['dob'],
      homeProfilePostPageDetailsRip: parsedJson['rip'],
      homeProfilePostPageDetailsCemetery: parsedJson['cemetery'],
      homeProfilePostPageDetailsCountry: parsedJson['country'],
    );
  }
}

class APIRegularHomeProfilePostExtendedPageCreator{
  int homeProfilePostPageCreatorId;
  String homeProfilePostPageCreatorFirstName;
  String homeProfilePostPageCreatorLastName;
  String homeProfilePostPageCreatorPhoneNumber;
  String homeProfilePostPageCreatorEmail;
  String homeProfilePostPageCreatorUserName;
  dynamic homeProfilePostPageCreatorImage;

  APIRegularHomeProfilePostExtendedPageCreator({this.homeProfilePostPageCreatorId, this.homeProfilePostPageCreatorFirstName, this.homeProfilePostPageCreatorLastName, this.homeProfilePostPageCreatorPhoneNumber, this.homeProfilePostPageCreatorEmail, this.homeProfilePostPageCreatorUserName, this.homeProfilePostPageCreatorImage});

  factory APIRegularHomeProfilePostExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeProfilePostExtendedPageCreator(
      homeProfilePostPageCreatorId: parsedJson['id'],
      homeProfilePostPageCreatorFirstName: parsedJson['first_name'],
      homeProfilePostPageCreatorLastName: parsedJson['last_name'],
      homeProfilePostPageCreatorPhoneNumber: parsedJson['phone_number'],
      homeProfilePostPageCreatorEmail: parsedJson['email'],
      homeProfilePostPageCreatorUserName: parsedJson['username'],
      homeProfilePostPageCreatorImage: parsedJson['image']
    );
  }
}

class APIRegularHomeProfilePostExtendedTagged{
  int homeProfilePostTaggedId;
  String homeProfilePostTaggedFirstName;
  String homeProfilePostTaggedLastName;
  String homeProfilePostTaggedImage;

  APIRegularHomeProfilePostExtendedTagged({this.homeProfilePostTaggedId, this.homeProfilePostTaggedFirstName, this.homeProfilePostTaggedLastName, this.homeProfilePostTaggedImage});

  factory APIRegularHomeProfilePostExtendedTagged.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeProfilePostExtendedTagged(
      homeProfilePostTaggedId: parsedJson['id'],
      homeProfilePostTaggedFirstName: parsedJson['first_name'],
      homeProfilePostTaggedLastName: parsedJson['last_name'],
      homeProfilePostTaggedImage: parsedJson['image']
    );
  }
}