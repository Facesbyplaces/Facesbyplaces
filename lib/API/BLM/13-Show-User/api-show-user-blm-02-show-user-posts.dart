import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

Future<APIBLMShowUsersPostsMain> apiBLMShowUserPosts({required int userId, required int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/users/posts?user_id=$userId&page=$page',
    options: Options(
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  print('The status code of users posts is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIBLMShowUsersPostsMain.fromJson(newData);
  }else{
    throw Exception('Failed to get the post');
  }

  // final http.Response response = await http.get(
  //   Uri.http('http://fbp.dev1.koda.ws/api/v1/users/posts?user_id=$userId&page=$page', ''),
  //   headers: <String, String>{
  //     'Content-Type': 'application/json',
  //     'access-token': getAccessToken,
  //     'uid': getUID,
  //     'client': getClient,
  //   }
  // );

  // if(response.statusCode == 200){
  //   var newValue = json.decode(response.body);
  //   return APIBLMShowUsersPostsMain.fromJson(newValue);
  // }else{
  //   throw Exception('Failed to get the post');
  // }
}

class APIBLMShowUsersPostsMain{
  int blmItemsRemaining;
  List<APIBLMShowUsersPostsExtended> blmFamilyMemorialList;

  APIBLMShowUsersPostsMain({required this.blmItemsRemaining, required this.blmFamilyMemorialList,});

  factory APIBLMShowUsersPostsMain.fromJson(Map<String, dynamic> parsedJson){
    var newList = parsedJson['posts'] as List;
    List<APIBLMShowUsersPostsExtended> familyMemorials = newList.map((i) => APIBLMShowUsersPostsExtended.fromJson(i)).toList();

    return APIBLMShowUsersPostsMain(
      blmItemsRemaining: parsedJson['itemsremaining'],
      blmFamilyMemorialList: familyMemorials,
    );
  }
}

class APIBLMShowUsersPostsExtended{
  int showUsersPostsId;
  APIBLMShowUsersPostsExtendedPage showUsersPostsPage;
  String showUsersPostsBody;
  String showUsersPostsLocation;
  double showUsersPostsLatitude;
  double showUsersPostsLongitude;
  List<dynamic> showUsersPostsImagesOrVideos;
  List<APIBLMShowUsersPostsExtendedTagged> showUsersPostsPostTagged;
  String showUsersPostsCreateAt;
  int showUsersPostsNumberOfLikes;
  int showUsersPostsNumberOfComments;
  bool showUsersPostsLikeStatus;

  APIBLMShowUsersPostsExtended({required this.showUsersPostsId, required this.showUsersPostsPage, required this.showUsersPostsBody, required this.showUsersPostsLocation, required this.showUsersPostsLatitude, required this.showUsersPostsLongitude, required this.showUsersPostsImagesOrVideos, required this.showUsersPostsPostTagged, required this.showUsersPostsCreateAt, required this.showUsersPostsNumberOfLikes, required this.showUsersPostsNumberOfComments, required this.showUsersPostsLikeStatus});

  factory APIBLMShowUsersPostsExtended.fromJson(Map<String, dynamic> parsedJson){
    
    List<dynamic>? newList1;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList1 = List<dynamic>.from(list);
    }

    var newList2 = parsedJson['tag_people'] as List;
    List<APIBLMShowUsersPostsExtendedTagged> taggedList = newList2.map((i) => APIBLMShowUsersPostsExtendedTagged.fromJson(i)).toList();
    
    return APIBLMShowUsersPostsExtended(
      showUsersPostsId: parsedJson['id'],
      showUsersPostsPage: APIBLMShowUsersPostsExtendedPage.fromJson(parsedJson['page']),
      showUsersPostsBody: parsedJson['body'],
      showUsersPostsLocation: parsedJson['location'],
      showUsersPostsLatitude: parsedJson['latitude'],
      showUsersPostsLongitude: parsedJson['longitude'],
      showUsersPostsImagesOrVideos: newList1!,
      showUsersPostsPostTagged: taggedList,
      showUsersPostsCreateAt: parsedJson['created_at'],
      showUsersPostsNumberOfLikes: parsedJson['numberOfLikes'],
      showUsersPostsNumberOfComments: parsedJson['numberOfComments'],
      showUsersPostsLikeStatus: parsedJson['likeStatus'],
    );
  }
}

class APIBLMShowUsersPostsExtendedPage{
  int showUsersPostsPageId;
  String showUsersPostsPageName;
  APIBLMShowUsersPostsExtendedPageDetails showUsersPostsPageDetails;
  dynamic showUsersPostsPageBackgroundImage;
  dynamic showUsersPostsPageProfileImage;
  dynamic showUsersPostsPageImagesOrVideos;
  String showUsersPostsPageRelationship;
  APIBLMShowUsersPostsExtendedPageCreator showUsersPostsPagePageCreator;
  bool showUsersPostsPageFollower;
  bool showUsersPostsPageManage;
  bool showUsersPostsPageFamOrFriends;
  String showUsersPostsPagePageType;
  String showUsersPostsPagePrivacy;

  APIBLMShowUsersPostsExtendedPage({required this.showUsersPostsPageId, required this.showUsersPostsPageName, required this.showUsersPostsPageDetails, required this.showUsersPostsPageBackgroundImage, required this.showUsersPostsPageProfileImage, required this.showUsersPostsPageImagesOrVideos, required this.showUsersPostsPageRelationship, required this.showUsersPostsPagePageCreator, required this.showUsersPostsPageFamOrFriends, required this.showUsersPostsPageFollower, required this.showUsersPostsPageManage, required this.showUsersPostsPagePageType, required this.showUsersPostsPagePrivacy});

  factory APIBLMShowUsersPostsExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowUsersPostsExtendedPage(
      showUsersPostsPageId: parsedJson['id'],
      showUsersPostsPageName: parsedJson['name'],
      showUsersPostsPageDetails: APIBLMShowUsersPostsExtendedPageDetails.fromJson(parsedJson['details']),
      showUsersPostsPageBackgroundImage: parsedJson['backgroundImage'],
      showUsersPostsPageProfileImage: parsedJson['profileImage'],
      showUsersPostsPageImagesOrVideos: parsedJson['imagesOrVideos'],
      showUsersPostsPageRelationship: parsedJson['relationship'],
      showUsersPostsPagePageCreator: APIBLMShowUsersPostsExtendedPageCreator.fromJson(parsedJson['page_creator']),
      showUsersPostsPageFollower: parsedJson['follower'],
      showUsersPostsPageManage: parsedJson['manage'],
      showUsersPostsPageFamOrFriends: parsedJson['famOrFriends'],
      showUsersPostsPagePageType: parsedJson['page_type'],
      showUsersPostsPagePrivacy: parsedJson['privacy'],
    );
  }
}

class APIBLMShowUsersPostsExtendedPageDetails{
  String showUsersPostsPageDetailsDescription;
  String showUsersPostsPageDetailsBirthPlace;
  String showUsersPostsPageDetailsDob;
  String showUsersPostsPageDetailsRip;
  String showUsersPostsPageDetailsCemetery;
  String showUsersPostsPageDetailsCountry;

  APIBLMShowUsersPostsExtendedPageDetails({required this.showUsersPostsPageDetailsDescription, required this.showUsersPostsPageDetailsBirthPlace, required this.showUsersPostsPageDetailsDob, required this.showUsersPostsPageDetailsRip, required this.showUsersPostsPageDetailsCemetery, required this.showUsersPostsPageDetailsCountry});

  factory APIBLMShowUsersPostsExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowUsersPostsExtendedPageDetails(
      showUsersPostsPageDetailsDescription: parsedJson['description'],
      showUsersPostsPageDetailsBirthPlace: parsedJson['birthplace'],
      showUsersPostsPageDetailsDob: parsedJson['dob'],
      showUsersPostsPageDetailsRip: parsedJson['rip'],
      showUsersPostsPageDetailsCemetery: parsedJson['cemetery'],
      showUsersPostsPageDetailsCountry: parsedJson['country'],
    );
  }
}

class APIBLMShowUsersPostsExtendedPageCreator{
  int showUsersPostsPageCreatorId;
  String showUsersPostsPageCreatorFirstName;
  String showUsersPostsPageCreatorLastName;
  String showUsersPostsPageCreatorPhoneNumber;
  String showUsersPostsPageCreatorEmail;
  String showUsersPostsPageCreatorUserName;
  dynamic showUsersPostsPageCreatorImage;

  APIBLMShowUsersPostsExtendedPageCreator({required this.showUsersPostsPageCreatorId, required this.showUsersPostsPageCreatorFirstName, required this.showUsersPostsPageCreatorLastName, required this.showUsersPostsPageCreatorPhoneNumber, required this.showUsersPostsPageCreatorEmail, required this.showUsersPostsPageCreatorUserName, required this.showUsersPostsPageCreatorImage});

  factory APIBLMShowUsersPostsExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowUsersPostsExtendedPageCreator(
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

class APIBLMShowUsersPostsExtendedTagged{
  int showUsersPostsTaggedId;
  String showUsersPostsTaggedFirstName;
  String showUsersPostsTaggedLastName;
  String showUsersPostsTaggedImage;

  APIBLMShowUsersPostsExtendedTagged({required this.showUsersPostsTaggedId, required this.showUsersPostsTaggedFirstName, required this.showUsersPostsTaggedLastName, required this.showUsersPostsTaggedImage});

  factory APIBLMShowUsersPostsExtendedTagged.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowUsersPostsExtendedTagged(
      showUsersPostsTaggedId: parsedJson['id'],
      showUsersPostsTaggedFirstName: parsedJson['first_name'],
      showUsersPostsTaggedLastName: parsedJson['last_name'],
      showUsersPostsTaggedImage: parsedJson['image']
    );
  }
}