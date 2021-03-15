import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIBLMShowOriginalPostMain> apiBLMShowOriginalPost({required int postId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/posts/$postId',
    options: Options(
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  print('The status code of feed is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIBLMShowOriginalPostMain.fromJson(newData);
  }else{
    throw Exception('Failed to get the post');
  }

  // final http.Response response = await http.get(
  //   Uri.http('http://fbp.dev1.koda.ws/api/v1/posts/$postId', ''),
  //   headers: <String, String>{
  //     'Content-Type': 'application/json',
  //     'access-token': getAccessToken,
  //     'uid': getUID,
  //     'client': getClient,
  //   }
  // );

  // if(response.statusCode == 200){
  //   var newValue = json.decode(response.body);
  //   return APIBLMShowOriginalPostMain.fromJson(newValue);
  // }else{
  //   throw Exception('Failed to get the post');
  // }
}

class APIBLMShowOriginalPostMain{
  APIBLMShowOriginalPostExtended blmPost;
  
  APIBLMShowOriginalPostMain({required this.blmPost});

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

  APIBLMShowOriginalPostExtended({required this.showOriginalPostId, required this.showOriginalPostPage, required this.showOriginalPostBody, required this.showOriginalPostLocation, required this.showOriginalPostLatitude, required this.showOriginalPostLongitude, required this.showOriginalPostImagesOrVideos, required this.showOriginalPostPostTagged, required this.showOriginalPostCreateAt, required this.showOriginalPostNumberOfLikes, required this.showOriginalPostNumberOfComments, required this.showOriginalPostLikeStatus});

  factory APIBLMShowOriginalPostExtended.fromJson(Map<String, dynamic> parsedJson){
    
    List<dynamic>? newList;

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
      showOriginalPostImagesOrVideos: newList!,
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

  APIBLMShowOriginalPostExtendedPage({required this.showOriginalPostPageId, required this.showOriginalPostPageName, required this.showOriginalPostPageDetails, required this.showOriginalPostPageBackgroundImage, required this.showOriginalPostPageProfileImage, required this.showOriginalPostPageImagesOrVideos, required this.showOriginalPostPageRelationship, required this.showOriginalPostPagePageCreator, required this.showOriginalPostPageManage, required this.showOriginalPostPageFamOrFriends, required this.showOriginalPostPageFollower, required this.showOriginalPostPagePageType, required this.showOriginalPostPagePrivacy});

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

  APIRegularShowOriginalPostExtendedPageDetails({required this.showOriginalPostPageDetailsDescription, required this.showOriginalPostPageDetailsBirthPlace, required this.showOriginalPostPageDetailsDob, required this.showOriginalPostPageDetailsRip, required this.showOriginalPostPageDetailsCemetery, required this.showOriginalPostPageDetailsCountry});

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

  APIBLMShowOriginalPostExtendedPageCreator({required this.showOriginalPostPageCreatorId, required this.showOriginalPostPageCreatorFirstName, required this.showOriginalPostPageCreatorLastName, required this.showOriginalPostPageCreatorPhoneNumber, required this.showOriginalPostPageCreatorEmail, required this.showOriginalPostPageCreatorUserName, this.showOriginalPostPageCreatorImage, required this.showOriginalPostPageCreatorAccountType});

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

  APIBLMShowOriginalPostExtendedTagged({required this.showOriginalPostTaggedId, required this.showOriginalPostTaggedFirstName, required this.showOriginalPostTaggedLastName, required this.showOriginalPostTaggedImage});

  factory APIBLMShowOriginalPostExtendedTagged.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowOriginalPostExtendedTagged(
      showOriginalPostTaggedId: parsedJson['id'],
      showOriginalPostTaggedFirstName: parsedJson['first_name'],
      showOriginalPostTaggedLastName: parsedJson['last_name'],
      showOriginalPostTaggedImage: parsedJson['image']
    );
  }
}