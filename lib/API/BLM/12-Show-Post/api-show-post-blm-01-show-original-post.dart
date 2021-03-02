import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowOriginalPostMain> apiBLMShowOriginalPost({int postId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

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
    return APIBLMShowOriginalPostMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the post');
  }
}

class APIBLMShowOriginalPostMain{
  APIBLMShowOriginalPostExtended blmPost;
  
  APIBLMShowOriginalPostMain({this.blmPost});

  factory APIBLMShowOriginalPostMain.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowOriginalPostMain(
      blmPost: APIBLMShowOriginalPostExtended.fromJson(parsedJson['post'])
    );
  }
}

class APIBLMShowOriginalPostExtended{
  int showOriginalPostId;
  APIBLMShowOriginalPostExtendedPage showOriginalPostPage;
  String showOriginalPostBody;
  String showOriginalPostLocation;
  double showOriginalPostLatitude;
  double showOriginalPostLongitude;
  List<dynamic> showOriginalPostImagesOrVideos;
  List<APIBLMShowOriginalPostExtendedTagged> showOriginalPostPostTagged;
  String showOriginalPostCreateAt;
  int showOriginalPostNumberOfLikes;
  int showOriginalPostNumberOfComments;
  bool showOriginalPostLikeStatus;

  APIBLMShowOriginalPostExtended({this.showOriginalPostId, this.showOriginalPostPage, this.showOriginalPostBody, this.showOriginalPostLocation, this.showOriginalPostLatitude, this.showOriginalPostLongitude, this.showOriginalPostImagesOrVideos, this.showOriginalPostPostTagged, this.showOriginalPostCreateAt, this.showOriginalPostNumberOfLikes, this.showOriginalPostNumberOfComments, this.showOriginalPostLikeStatus});

  factory APIBLMShowOriginalPostExtended.fromJson(Map<String, dynamic> parsedJson){
    
    List<dynamic> newList;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList = List<dynamic>.from(list);
    }

    var newList2 = parsedJson['tag_people'] as List;
    List<APIBLMShowOriginalPostExtendedTagged> taggedList = newList2.map((i) => APIBLMShowOriginalPostExtendedTagged.fromJson(i)).toList();    
    
    return APIBLMShowOriginalPostExtended(
      showOriginalPostId: parsedJson['id'],
      showOriginalPostPage: APIBLMShowOriginalPostExtendedPage.fromJson(parsedJson['page']),
      showOriginalPostBody: parsedJson['body'],
      showOriginalPostLocation: parsedJson['location'],
      showOriginalPostLatitude: parsedJson['latitude'],
      showOriginalPostLongitude: parsedJson['longitude'],
      showOriginalPostImagesOrVideos: newList,
      showOriginalPostPostTagged: taggedList,
      showOriginalPostCreateAt: parsedJson['created_at'],
      showOriginalPostNumberOfLikes: parsedJson['numberOfLikes'],
      showOriginalPostNumberOfComments: parsedJson['numberOfComments'],
      showOriginalPostLikeStatus: parsedJson['likeStatus'],
    );
  }
}

class APIBLMShowOriginalPostExtendedPage{
  int showOriginalPostPageId;
  String showOriginalPostPageName;
  APIRegularShowOriginalPostExtendedPageDetails showOriginalPostPageDetails;
  dynamic showOriginalPostPageBackgroundImage;
  dynamic showOriginalPostPageProfileImage;
  dynamic showOriginalPostPageImagesOrVideos;
  String showOriginalPostPageRelationship;
  APIBLMShowOriginalPostExtendedPageCreator showOriginalPostPagePageCreator;
  bool showOriginalPostPageManage;
  bool showOriginalPostPageFamOrFriends;
  bool showOriginalPostPageFollower;
  String showOriginalPostPagePageType;
  String showOriginalPostPagePrivacy;

  APIBLMShowOriginalPostExtendedPage({this.showOriginalPostPageId, this.showOriginalPostPageName, this.showOriginalPostPageDetails, this.showOriginalPostPageBackgroundImage, this.showOriginalPostPageProfileImage, this.showOriginalPostPageImagesOrVideos, this.showOriginalPostPageRelationship, this.showOriginalPostPagePageCreator, this.showOriginalPostPageManage, this.showOriginalPostPageFamOrFriends, this.showOriginalPostPageFollower, this.showOriginalPostPagePageType, this.showOriginalPostPagePrivacy});

  factory APIBLMShowOriginalPostExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowOriginalPostExtendedPage(
      showOriginalPostPageId: parsedJson['id'],
      showOriginalPostPageName: parsedJson['name'],
      showOriginalPostPageDetails: APIRegularShowOriginalPostExtendedPageDetails.fromJson(parsedJson['details']),
      showOriginalPostPageBackgroundImage: parsedJson['backgroundImage'],
      showOriginalPostPageProfileImage: parsedJson['profileImage'],
      showOriginalPostPageImagesOrVideos: parsedJson['imagesOrVideos'],
      showOriginalPostPageRelationship: parsedJson['relationship'],
      showOriginalPostPagePageCreator: APIBLMShowOriginalPostExtendedPageCreator.fromJson(parsedJson['page_creator']),
      showOriginalPostPageManage: parsedJson['manage'],
      showOriginalPostPageFamOrFriends: parsedJson['famOrFriends'],
      showOriginalPostPageFollower: parsedJson['follower'],
      showOriginalPostPagePageType: parsedJson['page_type'],
      showOriginalPostPagePrivacy: parsedJson['privacy'],
    );
  }
}

class APIRegularShowOriginalPostExtendedPageDetails{
  String showOriginalPostPageDetailsDescription;
  String showOriginalPostPageDetailsBirthPlace;
  String showOriginalPostPageDetailsDob;
  String showOriginalPostPageDetailsRip;
  String showOriginalPostPageDetailsCemetery;
  String showOriginalPostPageDetailsCountry;

  APIRegularShowOriginalPostExtendedPageDetails({this.showOriginalPostPageDetailsDescription, this.showOriginalPostPageDetailsBirthPlace, this.showOriginalPostPageDetailsDob, this.showOriginalPostPageDetailsRip, this.showOriginalPostPageDetailsCemetery, this.showOriginalPostPageDetailsCountry});

  factory APIRegularShowOriginalPostExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowOriginalPostExtendedPageDetails(
      showOriginalPostPageDetailsDescription: parsedJson['description'],
      showOriginalPostPageDetailsBirthPlace: parsedJson['birthplace'],
      showOriginalPostPageDetailsDob: parsedJson['dob'],
      showOriginalPostPageDetailsRip: parsedJson['rip'],
      showOriginalPostPageDetailsCemetery: parsedJson['cemetery'],
      showOriginalPostPageDetailsCountry: parsedJson['country'],
    );
  }
}

class APIBLMShowOriginalPostExtendedPageCreator{
  int showOriginalPostPageCreatorId;
  String showOriginalPostPageCreatorFirstName;
  String showOriginalPostPageCreatorLastName;
  String showOriginalPostPageCreatorPhoneNumber;
  String showOriginalPostPageCreatorEmail;
  String showOriginalPostPageCreatorUserName;
  dynamic showOriginalPostPageCreatorImage;
  int showOriginalPostPageCreatorAccountType;

  APIBLMShowOriginalPostExtendedPageCreator({this.showOriginalPostPageCreatorId, this.showOriginalPostPageCreatorFirstName, this.showOriginalPostPageCreatorLastName, this.showOriginalPostPageCreatorPhoneNumber, this.showOriginalPostPageCreatorEmail, this.showOriginalPostPageCreatorUserName, this.showOriginalPostPageCreatorImage, this.showOriginalPostPageCreatorAccountType});

  factory APIBLMShowOriginalPostExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowOriginalPostExtendedPageCreator(
      showOriginalPostPageCreatorId: parsedJson['id'],
      showOriginalPostPageCreatorFirstName: parsedJson['first_name'],
      showOriginalPostPageCreatorLastName: parsedJson['last_name'],
      showOriginalPostPageCreatorPhoneNumber: parsedJson['phone_number'],
      showOriginalPostPageCreatorEmail: parsedJson['email'],
      showOriginalPostPageCreatorUserName: parsedJson['username'],
      showOriginalPostPageCreatorImage: parsedJson['image'],
      showOriginalPostPageCreatorAccountType: parsedJson['account_type'],
    );
  }
}

class APIBLMShowOriginalPostExtendedTagged{
  int showOriginalPostTaggedId;
  String showOriginalPostTaggedFirstName;
  String showOriginalPostTaggedLastName;
  String showOriginalPostTaggedImage;

  APIBLMShowOriginalPostExtendedTagged({this.showOriginalPostTaggedId, this.showOriginalPostTaggedFirstName, this.showOriginalPostTaggedLastName, this.showOriginalPostTaggedImage});

  factory APIBLMShowOriginalPostExtendedTagged.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowOriginalPostExtendedTagged(
      showOriginalPostTaggedId: parsedJson['id'],
      showOriginalPostTaggedFirstName: parsedJson['first_name'],
      showOriginalPostTaggedLastName: parsedJson['last_name'],
      showOriginalPostTaggedImage: parsedJson['image']
    );
  }
}