import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIBLMHomeTabFeedMain> apiBLMHomeFeedTab({required int page}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  // var response = await dioRequest.get('http://45.33.66.25:3001/api/v1/mainpages/feed/?page=$page',
  var response = await dioRequest.get('http://facesbyplaces.com/api/v1/mainpages/feed/?page=$page',
    options: Options(
      followRedirects: false,
      validateStatus: (status){
        return status! < 600;
      },
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  print('The status code of blm home feed tab is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIBLMHomeTabFeedMain.fromJson(newData);
  }else{
    throw Exception('Failed to get the feed');
  }
}

class APIBLMHomeTabFeedMain{
  int blmItemsRemaining;
  List<APIBLMHomeTabFeedExtended> blmFamilyMemorialList;
  APIBLMHomeTabFeedMain({required this.blmFamilyMemorialList, required this.blmItemsRemaining});

  factory APIBLMHomeTabFeedMain.fromJson(Map<String, dynamic> parsedJson){
    var newList = parsedJson['posts'] as List;
    List<APIBLMHomeTabFeedExtended> familyMemorials = newList.map((i) => APIBLMHomeTabFeedExtended.fromJson(i)).toList();
    return APIBLMHomeTabFeedMain(
      blmFamilyMemorialList: familyMemorials,
      blmItemsRemaining: parsedJson['itemsremaining'],
    );
  }
}

class APIBLMHomeTabFeedExtended{
  int homeTabFeedId;
  APIBLMHomeTabFeedExtendedPage homeTabFeedPage;
  String homeTabFeedBody;
  String homeTabFeedLocation;
  double homeTabFeedLatitude;
  double homeTabFeedLongitude;
  List<dynamic> homeTabFeedImagesOrVideos;
  List<APIBLMHomeTabFeedExtendedTagged> homeTabFeedPostTagged;
  String homeTabFeedCreatedAt;
  int homeTabFeedNumberOfLikes;
  int homeTabFeedNumberOfComments;
  bool homeTabFeedLikeStatus;
  APIBLMHomeTabFeedExtended({required this.homeTabFeedId, required this.homeTabFeedPage, required this.homeTabFeedBody, required this.homeTabFeedLocation, required this.homeTabFeedLatitude, required this.homeTabFeedLongitude, required this.homeTabFeedImagesOrVideos, required this.homeTabFeedPostTagged, required this.homeTabFeedCreatedAt, required this.homeTabFeedNumberOfLikes, required this.homeTabFeedNumberOfComments, required this.homeTabFeedLikeStatus});

  factory APIBLMHomeTabFeedExtended.fromJson(Map<String, dynamic> parsedJson){
    
    List<dynamic>? newList1;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList1 = List<dynamic>.from(list);
    }

    var newList2 = parsedJson['tag_people'] as List;
    List<APIBLMHomeTabFeedExtendedTagged> taggedList = newList2.map((i) => APIBLMHomeTabFeedExtendedTagged.fromJson(i)).toList();
    
    return APIBLMHomeTabFeedExtended(
      homeTabFeedId: parsedJson['id'],
      homeTabFeedPage: APIBLMHomeTabFeedExtendedPage.fromJson(parsedJson['page']),
      homeTabFeedBody: parsedJson['body'] != null ? parsedJson['body'] : '',
      homeTabFeedLocation: parsedJson['location'] != null ? parsedJson['location'] : '',
      homeTabFeedLatitude: parsedJson['latitude'],
      homeTabFeedLongitude: parsedJson['longitude'],
      homeTabFeedImagesOrVideos: newList1 != null ? newList1 : [],
      homeTabFeedPostTagged: taggedList,
      homeTabFeedCreatedAt: parsedJson['created_at'] != null ? parsedJson['created_at'] : '',
      homeTabFeedNumberOfLikes: parsedJson['numberOfLikes'],
      homeTabFeedNumberOfComments: parsedJson['numberOfComments'],
      homeTabFeedLikeStatus: parsedJson['likeStatus'],
    );
  }
}

class APIBLMHomeTabFeedExtendedPage{
  int homeTabFeedPageId;
  String homeTabFeedPageName;
  String homeTabFeedPageProfileImage;
  String homeTabFeedPageRelationship;
  APIBLMHomeTabFeedExtendedPageCreator homeTabFeedPagePageCreator;
  bool homeTabFeedPageManage;
  bool homeTabFeedPageFamOrFriends;
  bool homeTabFeedPageFollower;
  String homeTabFeedPagePageType;
  APIBLMHomeTabFeedExtendedPage({required this.homeTabFeedPageId, required this.homeTabFeedPageName, required this.homeTabFeedPageProfileImage, required this.homeTabFeedPageRelationship, required this.homeTabFeedPagePageCreator, required this.homeTabFeedPageManage, required this.homeTabFeedPageFamOrFriends, required this.homeTabFeedPageFollower, required this.homeTabFeedPagePageType,});

  factory APIBLMHomeTabFeedExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeTabFeedExtendedPage(
      homeTabFeedPageId: parsedJson['id'],
      homeTabFeedPageName: parsedJson['name'] != null ? parsedJson['name'] : '',
      homeTabFeedPageProfileImage: parsedJson['profileImage'] != null ? parsedJson['profileImage'] : '',
      homeTabFeedPageRelationship: parsedJson['relationship'] != null ? parsedJson['relationship'] : '',
      homeTabFeedPagePageCreator: APIBLMHomeTabFeedExtendedPageCreator.fromJson(parsedJson['page_creator']),
      homeTabFeedPageManage: parsedJson['manage'],
      homeTabFeedPageFamOrFriends: parsedJson['famOrFriends'],
      homeTabFeedPageFollower: parsedJson['follower'],
      homeTabFeedPagePageType: parsedJson['page_type'] != null ? parsedJson['page_type'] : '',
    );
  }
}

class APIBLMHomeTabFeedExtendedPageCreator{
  int homeTabFeedPageCreatorId;
  APIBLMHomeTabFeedExtendedPageCreator({required this.homeTabFeedPageCreatorId,});

  factory APIBLMHomeTabFeedExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeTabFeedExtendedPageCreator(
      homeTabFeedPageCreatorId: parsedJson['id'],
    );
  }
}

class APIBLMHomeTabFeedExtendedTagged{
  int homeTabFeedTaggedId;
  String homeTabFeedTaggedFirstName;
  String homeTabFeedTaggedLastName;
  String homeTabFeedTaggedImage;
  APIBLMHomeTabFeedExtendedTagged({required this.homeTabFeedTaggedId, required this.homeTabFeedTaggedFirstName, required this.homeTabFeedTaggedLastName, required this.homeTabFeedTaggedImage});

  factory APIBLMHomeTabFeedExtendedTagged.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeTabFeedExtendedTagged(
      homeTabFeedTaggedId: parsedJson['id'],
      homeTabFeedTaggedFirstName: parsedJson['first_name'] != null ? parsedJson['first_name'] : '',
      homeTabFeedTaggedLastName: parsedJson['last_name'] != null ? parsedJson['last_name'] : '',
      homeTabFeedTaggedImage: parsedJson['image'] != null ? parsedJson['image'] : '',
    );
  }
}