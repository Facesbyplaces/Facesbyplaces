import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowOriginalPostMainMain> apiBLMShowOriginalPost({int postId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  print('The post id is $postId');

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/posts/$postId',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The status code of original post is ${response.statusCode}');
  print('The status body of original post is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMShowOriginalPostMainMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the post');
  }
}

class APIBLMShowOriginalPostMainMain{
  APIBLMShowOriginalPostMainExtended blmPost;
  
  APIBLMShowOriginalPostMainMain({this.blmPost});

  factory APIBLMShowOriginalPostMainMain.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowOriginalPostMainMain(
      blmPost: APIBLMShowOriginalPostMainExtended.fromJson(parsedJson['post'])
    );
  }
}


class APIBLMShowOriginalPostMainExtended{
  int showOriginalPostId;
  APIBLMShowOriginalPostMainExtendedPage showOriginalPostPage;
  String showOriginalPostBody;
  String showOriginalPostLocation;
  double showOriginalPostLatitude;
  double showOriginalPostLongitude;
  List<dynamic> showOriginalPostImagesOrVideos;
  List<APIBLMHomeProfilePostExtendedTagged> showOriginalPostPostTagged;
  String showOriginalPostCreateAt;
  int showOriginalPostNumberOfLikes;
  int showOriginalPostNumberOfComments;
  bool showOriginalPostLikeStatus;

  APIBLMShowOriginalPostMainExtended({this.showOriginalPostId, this.showOriginalPostPage, this.showOriginalPostBody, this.showOriginalPostLocation, this.showOriginalPostLatitude, this.showOriginalPostLongitude, this.showOriginalPostImagesOrVideos, this.showOriginalPostPostTagged, this.showOriginalPostCreateAt, this.showOriginalPostNumberOfLikes, this.showOriginalPostNumberOfComments, this.showOriginalPostLikeStatus});

  factory APIBLMShowOriginalPostMainExtended.fromJson(Map<String, dynamic> parsedJson){
    
    List<dynamic> newList;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList = List<dynamic>.from(list);
    }

    var newList2 = parsedJson['tag_people'] as List;
    List<APIBLMHomeProfilePostExtendedTagged> taggedList = newList2.map((i) => APIBLMHomeProfilePostExtendedTagged.fromJson(i)).toList();    
    
    return APIBLMShowOriginalPostMainExtended(
      showOriginalPostId: parsedJson['id'],
      showOriginalPostPage: APIBLMShowOriginalPostMainExtendedPage.fromJson(parsedJson['page']),
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

class APIBLMShowOriginalPostMainExtendedPage{
  int showOriginalPostPageId;
  String showOriginalPostPageName;
  APIRegularShowOriginalPostMainExtendedPageDetails showOriginalPostPageDetails;
  dynamic showOriginalPostPageBackgroundImage;
  dynamic showOriginalPostPageProfileImage;
  dynamic showOriginalPostPageImagesOrVideos;
  String showOriginalPostPageRelationship;
  APIBLMShowOriginalPostMainExtendedPageCreator showOriginalPostPagePageCreator;
  bool showOriginalPostPageManage;
  bool showOriginalPostPageFamOrFriends;
  bool showOriginalPostPageFollower;
  String showOriginalPostPagePageType;
  String showOriginalPostPagePrivacy;

  APIBLMShowOriginalPostMainExtendedPage({this.showOriginalPostPageId, this.showOriginalPostPageName, this.showOriginalPostPageDetails, this.showOriginalPostPageBackgroundImage, this.showOriginalPostPageProfileImage, this.showOriginalPostPageImagesOrVideos, this.showOriginalPostPageRelationship, this.showOriginalPostPagePageCreator, this.showOriginalPostPageManage, this.showOriginalPostPageFamOrFriends, this.showOriginalPostPageFollower, this.showOriginalPostPagePageType, this.showOriginalPostPagePrivacy});

  factory APIBLMShowOriginalPostMainExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowOriginalPostMainExtendedPage(
      showOriginalPostPageId: parsedJson['id'],
      showOriginalPostPageName: parsedJson['name'],
      showOriginalPostPageDetails: APIRegularShowOriginalPostMainExtendedPageDetails.fromJson(parsedJson['details']),
      showOriginalPostPageBackgroundImage: parsedJson['backgroundImage'],
      showOriginalPostPageProfileImage: parsedJson['profileImage'],
      showOriginalPostPageImagesOrVideos: parsedJson['imagesOrVideos'],
      showOriginalPostPageRelationship: parsedJson['relationship'],
      showOriginalPostPagePageCreator: APIBLMShowOriginalPostMainExtendedPageCreator.fromJson(parsedJson['page_creator']),
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

class APIBLMShowOriginalPostMainExtendedPageCreator{
  int showOriginalPostPageCreatorId;
  String showOriginalPostPageCreatorFirstName;
  String showOriginalPostPageCreatorLastName;
  String showOriginalPostPageCreatorPhoneNumber;
  String showOriginalPostPageCreatorEmail;
  String showOriginalPostPageCreatorUserName;
  dynamic showOriginalPostPageCreatorImage;

  APIBLMShowOriginalPostMainExtendedPageCreator({this.showOriginalPostPageCreatorId, this.showOriginalPostPageCreatorFirstName, this.showOriginalPostPageCreatorLastName, this.showOriginalPostPageCreatorPhoneNumber, this.showOriginalPostPageCreatorEmail, this.showOriginalPostPageCreatorUserName, this.showOriginalPostPageCreatorImage});

  factory APIBLMShowOriginalPostMainExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowOriginalPostMainExtendedPageCreator(
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

class APIBLMHomeProfilePostExtendedTagged{
  int showOriginalPostTaggedId;
  String showOriginalPostTaggedFirstName;
  String showOriginalPostTaggedLastName;
  String showOriginalPostTaggedImage;

  APIBLMHomeProfilePostExtendedTagged({this.showOriginalPostTaggedId, this.showOriginalPostTaggedFirstName, this.showOriginalPostTaggedLastName, this.showOriginalPostTaggedImage});

  factory APIBLMHomeProfilePostExtendedTagged.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeProfilePostExtendedTagged(
      showOriginalPostTaggedId: parsedJson['id'],
      showOriginalPostTaggedFirstName: parsedJson['first_name'],
      showOriginalPostTaggedLastName: parsedJson['last_name'],
      showOriginalPostTaggedImage: parsedJson['image']
    );
  }
}