import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowOriginalPostMain> apiRegularShowOriginalPost({int postId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/posts/$postId',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularShowOriginalPostMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the post');
  }
}

class APIRegularShowOriginalPostMain{
  APIRegularShowOriginalPostMainExtended almPost;

  APIRegularShowOriginalPostMain({this.almPost});

  factory APIRegularShowOriginalPostMain.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowOriginalPostMain(
      almPost: APIRegularShowOriginalPostMainExtended.fromJson(parsedJson['post'])
    );
  }
}

class APIRegularShowOriginalPostMainExtended{
  int showOriginalPostId;
  APIRegularShowOriginalPostMainExtendedPage showOriginalPostPage;
  String showOriginalPostBody;
  String showOriginalPostLocation;
  double showOriginalPostLatitude;
  double showOriginalPostLongitude;
  List<dynamic> showOriginalPostImagesOrVideos;
  List<APIRegularShowOriginalPostExtendedTagged> showOriginalPostPostTagged;
  String showOriginalPostCreateAt;
  int showOriginalPostNumberOfLikes;
  int showOriginalPostNumberOfComments;
  bool showOriginalPostLikeStatus;

  APIRegularShowOriginalPostMainExtended({this.showOriginalPostId, this.showOriginalPostPage, this.showOriginalPostBody, this.showOriginalPostLocation, this.showOriginalPostLatitude, this.showOriginalPostLongitude, this.showOriginalPostImagesOrVideos, this.showOriginalPostPostTagged, this.showOriginalPostCreateAt, this.showOriginalPostNumberOfLikes, this.showOriginalPostNumberOfComments, this.showOriginalPostLikeStatus});

  factory APIRegularShowOriginalPostMainExtended.fromJson(Map<String, dynamic> parsedJson){
    
    List<dynamic> newList1;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList1 = List<dynamic>.from(list);
    }
    
    var newList2 = parsedJson['tag_people'] as List;
    List<APIRegularShowOriginalPostExtendedTagged> taggedList = newList2.map((i) => APIRegularShowOriginalPostExtendedTagged.fromJson(i)).toList();    

    return APIRegularShowOriginalPostMainExtended(
      showOriginalPostId: parsedJson['id'],
      showOriginalPostPage: APIRegularShowOriginalPostMainExtendedPage.fromJson(parsedJson['page']),
      showOriginalPostBody: parsedJson['body'],
      showOriginalPostLocation: parsedJson['location'],
      showOriginalPostLatitude: parsedJson['latitude'],
      showOriginalPostLongitude: parsedJson['longitude'],
      showOriginalPostImagesOrVideos: newList1,
      showOriginalPostPostTagged: taggedList,
      showOriginalPostCreateAt: parsedJson['created_at'],
      showOriginalPostNumberOfLikes: parsedJson['numberOfLikes'],
      showOriginalPostNumberOfComments: parsedJson['numberOfComments'],
      showOriginalPostLikeStatus: parsedJson['likeStatus'],
    );
  }
}

class APIRegularShowOriginalPostMainExtendedPage{
  int showOriginalPostPageId;
  String showOriginalPostPageName;
  APIRegularShowOriginalPostMainExtendedPageDetails showOriginalPostPageDetails;
  dynamic showOriginalPostPageBackgroundImage;
  dynamic showOriginalPostPageProfileImage;
  dynamic showOriginalPostPageImagesOrVideos;
  String showOriginalPostPageRelationship;
  APIRegularShowOriginalPostMainExtendedPageCreator showOriginalPostPagePageCreator;
  bool showOriginalPostPageManage;
  bool showOriginalPostPageFamOrFriends;
  bool showOriginalPostPageFollower;
  String showOriginalPostPagePageType;
  String showOriginalPostPagePrivacy;

  APIRegularShowOriginalPostMainExtendedPage({this.showOriginalPostPageId, this.showOriginalPostPageName, this.showOriginalPostPageDetails, this.showOriginalPostPageBackgroundImage, this.showOriginalPostPageProfileImage, this.showOriginalPostPageImagesOrVideos, this.showOriginalPostPageRelationship, this.showOriginalPostPagePageCreator, this.showOriginalPostPageManage, this.showOriginalPostPageFamOrFriends, this.showOriginalPostPageFollower, this.showOriginalPostPagePageType, this.showOriginalPostPagePrivacy});

  factory APIRegularShowOriginalPostMainExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowOriginalPostMainExtendedPage(
      showOriginalPostPageId: parsedJson['id'],
      showOriginalPostPageName: parsedJson['name'],
      showOriginalPostPageDetails: APIRegularShowOriginalPostMainExtendedPageDetails.fromJson(parsedJson['details']),
      showOriginalPostPageBackgroundImage: parsedJson['backgroundImage'],
      showOriginalPostPageProfileImage: parsedJson['profileImage'],
      showOriginalPostPageImagesOrVideos: parsedJson['imagesOrVideos'],
      showOriginalPostPageRelationship: parsedJson['relationship'],
      showOriginalPostPagePageCreator: APIRegularShowOriginalPostMainExtendedPageCreator.fromJson(parsedJson['page_creator']),
      showOriginalPostPageManage: parsedJson['manage'],
      showOriginalPostPageFamOrFriends: parsedJson['famOrFriends'],
      showOriginalPostPageFollower: parsedJson['follower'],
      showOriginalPostPagePageType: parsedJson['page_type'],
      showOriginalPostPagePrivacy: parsedJson['privacy'],
    );
  }
}

class APIRegularShowOriginalPostMainExtendedPageDetails{
  String showOriginalPostPageDetailsDescription;
  String showOriginalPostPageDetailsBirthPlace;
  String showOriginalPostPageDetailsDob;
  String showOriginalPostPageDetailsRip;
  String showOriginalPostPageDetailsCemetery;
  String showOriginalPostPageDetailsCountry;

  APIRegularShowOriginalPostMainExtendedPageDetails({this.showOriginalPostPageDetailsDescription, this.showOriginalPostPageDetailsBirthPlace, this.showOriginalPostPageDetailsDob, this.showOriginalPostPageDetailsRip, this.showOriginalPostPageDetailsCemetery, this.showOriginalPostPageDetailsCountry});

  factory APIRegularShowOriginalPostMainExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowOriginalPostMainExtendedPageDetails(
      showOriginalPostPageDetailsDescription: parsedJson['description'],
      showOriginalPostPageDetailsBirthPlace: parsedJson['birthplace'],
      showOriginalPostPageDetailsDob: parsedJson['dob'],
      showOriginalPostPageDetailsRip: parsedJson['rip'],
      showOriginalPostPageDetailsCemetery: parsedJson['cemetery'],
      showOriginalPostPageDetailsCountry: parsedJson['country'],
    );
  }
}

class APIRegularShowOriginalPostMainExtendedPageCreator{
  int showOriginalPostPageCreatorId;
  String showOriginalPostPageCreatorFirstName;
  String showOriginalPostPageCreatorLastName;
  String showOriginalPostPageCreatorPhoneNumber;
  String showOriginalPostPageCreatorEmail;
  String showOriginalPostPageCreatorUserName;
  dynamic showOriginalPostPageCreatorImage;

  APIRegularShowOriginalPostMainExtendedPageCreator({this.showOriginalPostPageCreatorId, this.showOriginalPostPageCreatorFirstName, this.showOriginalPostPageCreatorLastName, this.showOriginalPostPageCreatorPhoneNumber, this.showOriginalPostPageCreatorEmail, this.showOriginalPostPageCreatorUserName, this.showOriginalPostPageCreatorImage});

  factory APIRegularShowOriginalPostMainExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowOriginalPostMainExtendedPageCreator(
      showOriginalPostPageCreatorId: parsedJson['id'],
      showOriginalPostPageCreatorFirstName: parsedJson['first_name'],
      showOriginalPostPageCreatorLastName: parsedJson['last_name'],
      showOriginalPostPageCreatorPhoneNumber: parsedJson['phone_number'],
      showOriginalPostPageCreatorEmail: parsedJson['email'],
      showOriginalPostPageCreatorUserName: parsedJson['username'],
      showOriginalPostPageCreatorImage: parsedJson['image']
    );
  }
}

class APIRegularShowOriginalPostExtendedTagged{
  int showOriginalPostTaggedId;
  String showOriginalPostTaggedFirstName;
  String showOriginalPostTaggedLastName;
  String showOriginalPostTaggedImage;

  APIRegularShowOriginalPostExtendedTagged({this.showOriginalPostTaggedId, this.showOriginalPostTaggedFirstName, this.showOriginalPostTaggedLastName, this.showOriginalPostTaggedImage});

  factory APIRegularShowOriginalPostExtendedTagged.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowOriginalPostExtendedTagged(
      showOriginalPostTaggedId: parsedJson['id'],
      showOriginalPostTaggedFirstName: parsedJson['first_name'],
      showOriginalPostTaggedLastName: parsedJson['last_name'],
      showOriginalPostTaggedImage: parsedJson['image']
    );
  }
}