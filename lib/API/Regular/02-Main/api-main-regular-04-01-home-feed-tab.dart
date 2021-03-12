import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularHomeTabFeedMain> apiRegularHomeFeedTab({required int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get(
    Uri.http('fbp.dev1.koda.ws', '/api/v1/mainpages/feed/', {'page' : '$page',}),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );
  
  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularHomeTabFeedMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the feed');
  }
}

class APIRegularHomeTabFeedMain{
  int almItemsRemaining;
  List<APIRegularHomeTabFeedExtended> almFamilyMemorialList;

  APIRegularHomeTabFeedMain({required this.almItemsRemaining, required this.almFamilyMemorialList});

  factory APIRegularHomeTabFeedMain.fromJson(Map<String, dynamic> parsedJson){
    var newList = parsedJson['posts'] as List;
    List<APIRegularHomeTabFeedExtended> familyMemorials = newList.map((i) => APIRegularHomeTabFeedExtended.fromJson(i)).toList();

    return APIRegularHomeTabFeedMain(
      almItemsRemaining: parsedJson['itemsremaining'],
      almFamilyMemorialList: familyMemorials,
    );
  }
}

class APIRegularHomeTabFeedExtended{
  int homeTabFeedId;
  APIRegularHomeTabFeedExtendedPage homeTabFeedPage;
  String homeTabFeedBody;
  List<dynamic> homeTabFeedImagesOrVideos;
  List<APIRegularHomeTabFeedExtendedTagged> homeTabFeedPostTagged;
  String homeTabFeedCreateAt;
  int homeTabFeedNumberOfLikes;
  int homeTabFeedNumberOfComments;
  bool homeTabFeedLikeStatus;

  APIRegularHomeTabFeedExtended({required this.homeTabFeedId, required this.homeTabFeedPage, required this.homeTabFeedBody, required this.homeTabFeedImagesOrVideos, required this.homeTabFeedPostTagged, required this.homeTabFeedCreateAt, required this.homeTabFeedNumberOfLikes, required this.homeTabFeedNumberOfComments, required this.homeTabFeedLikeStatus});

  factory APIRegularHomeTabFeedExtended.fromJson(Map<String, dynamic> parsedJson){
    
    List<dynamic>? newList1;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList1 = List<dynamic>.from(list);
    }

    var newList2 = parsedJson['tag_people'] as List;
    List<APIRegularHomeTabFeedExtendedTagged> taggedList = newList2.map((i) => APIRegularHomeTabFeedExtendedTagged.fromJson(i)).toList();
    
    return APIRegularHomeTabFeedExtended(
      homeTabFeedId: parsedJson['id'],
      homeTabFeedPage: APIRegularHomeTabFeedExtendedPage.fromJson(parsedJson['page']),
      homeTabFeedBody: parsedJson['body'] != null ? parsedJson['body'] : '',
      homeTabFeedImagesOrVideos: newList1 != null ? newList1 : [],
      homeTabFeedPostTagged: taggedList,
      homeTabFeedCreateAt: parsedJson['created_at'] != null ? parsedJson['created_at'] : '',
      homeTabFeedNumberOfLikes: parsedJson['numberOfLikes'],
      homeTabFeedNumberOfComments: parsedJson['numberOfComments'],
      homeTabFeedLikeStatus: parsedJson['likeStatus'],
    );
  }
}

class APIRegularHomeTabFeedExtendedPage{
  int homeTabFeedPageId;
  String homeTabFeedPageName;
  String homeTabFeedPageProfileImage;
  String homeTabFeedPageRelationship;
  APIRegularHomeTabFeedExtendedPageCreator homeTabFeedPagePageCreator;
  bool homeTabFeedPageManage;
  bool homeTabFeedPageFamOrFriends;
  bool homeTabFeedPageFollower;
  String homeTabFeedPagePageType;

  APIRegularHomeTabFeedExtendedPage({required this.homeTabFeedPageId, required this.homeTabFeedPageName, required this.homeTabFeedPageProfileImage, required this.homeTabFeedPageRelationship, required this.homeTabFeedPagePageCreator, required this.homeTabFeedPageFollower, required this.homeTabFeedPageManage, required this.homeTabFeedPageFamOrFriends, required this.homeTabFeedPagePageType});

  factory APIRegularHomeTabFeedExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeTabFeedExtendedPage(
      homeTabFeedPageId: parsedJson['id'],
      homeTabFeedPageName: parsedJson['name'] != null ? parsedJson['name'] : '',
      homeTabFeedPageProfileImage: parsedJson['profileImage'] != null ? parsedJson['profileImage'] : '',
      homeTabFeedPageRelationship: parsedJson['relationship'] != null ? parsedJson['relationship'] : '',
      homeTabFeedPagePageCreator: APIRegularHomeTabFeedExtendedPageCreator.fromJson(parsedJson['page_creator']),
      homeTabFeedPageFollower: parsedJson['follower'],
      homeTabFeedPageManage: parsedJson['manage'],
      homeTabFeedPageFamOrFriends: parsedJson['famOrFriends'],
      homeTabFeedPagePageType: parsedJson['page_type'] != null ? parsedJson['page_type'] : '',
    );
  }
}

class APIRegularHomeTabFeedExtendedPageCreator{
  int homeTabFeedPageCreatorId;

  APIRegularHomeTabFeedExtendedPageCreator({required this.homeTabFeedPageCreatorId});

  factory APIRegularHomeTabFeedExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeTabFeedExtendedPageCreator(
      homeTabFeedPageCreatorId: parsedJson['id'],
    );
  }
}

class APIRegularHomeTabFeedExtendedTagged{
  int homeTabFeedTaggedId;
  String homeTabFeedTaggedFirstName;
  String homeTabFeedTaggedLastName;
  String homeTabFeedTaggedImage;

  APIRegularHomeTabFeedExtendedTagged({required this.homeTabFeedTaggedId, required this.homeTabFeedTaggedFirstName, required this.homeTabFeedTaggedLastName, required this.homeTabFeedTaggedImage});

  factory APIRegularHomeTabFeedExtendedTagged.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeTabFeedExtendedTagged(
      homeTabFeedTaggedId: parsedJson['id'],
      homeTabFeedTaggedFirstName: parsedJson['first_name'] != null ? parsedJson['first_name'] : '',
      homeTabFeedTaggedLastName: parsedJson['last_name'] != null ? parsedJson['last_name'] : '',
      homeTabFeedTaggedImage: parsedJson['image'] != null ? parsedJson['image'] : '',
    );
  }
}