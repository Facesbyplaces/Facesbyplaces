import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

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

  print('The status code of blm show user posts is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIBLMShowUsersPostsMain.fromJson(newData);
  }else{
    throw Exception('Failed to get the post');
  }
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
  List<dynamic> showUsersPostsImagesOrVideos;
  List<APIBLMShowUsersPostsExtendedTagged> showUsersPostsPostTagged;
  String showUsersPostsCreatedAt;
  int showUsersPostsNumberOfLikes;
  int showUsersPostsNumberOfComments;
  bool showUsersPostsLikeStatus;

  APIBLMShowUsersPostsExtended({required this.showUsersPostsId, required this.showUsersPostsPage, required this.showUsersPostsBody, required this.showUsersPostsImagesOrVideos, required this.showUsersPostsPostTagged, required this.showUsersPostsCreatedAt, required this.showUsersPostsNumberOfLikes, required this.showUsersPostsNumberOfComments, required this.showUsersPostsLikeStatus});

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
      showUsersPostsBody: parsedJson['body'] != null ? parsedJson['body'] : '',
      showUsersPostsImagesOrVideos: newList1 != null ? newList1 : [],
      showUsersPostsPostTagged: taggedList,
      showUsersPostsCreatedAt: parsedJson['created_at'] != null ? parsedJson['created_at'] : '',
      showUsersPostsNumberOfLikes: parsedJson['numberOfLikes'],
      showUsersPostsNumberOfComments: parsedJson['numberOfComments'],
      showUsersPostsLikeStatus: parsedJson['likeStatus'],
    );
  }
}

class APIBLMShowUsersPostsExtendedPage{
  int showUsersPostsPageId;
  String showUsersPostsPageName;
  String showUsersPostsPageProfileImage;
  String showUsersPostsPageRelationship;
  APIBLMShowUsersPostsExtendedPageCreator showUsersPostsPagePageCreator;
  bool showUsersPostsPageFollower;
  bool showUsersPostsPageManage;
  bool showUsersPostsPageFamOrFriends;
  String showUsersPostsPagePageType;

  APIBLMShowUsersPostsExtendedPage({required this.showUsersPostsPageId, required this.showUsersPostsPageName, required this.showUsersPostsPageProfileImage, required this.showUsersPostsPageRelationship, required this.showUsersPostsPagePageCreator, required this.showUsersPostsPageFamOrFriends, required this.showUsersPostsPageFollower, required this.showUsersPostsPageManage, required this.showUsersPostsPagePageType,});

  factory APIBLMShowUsersPostsExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowUsersPostsExtendedPage(
      showUsersPostsPageId: parsedJson['id'],
      showUsersPostsPageName: parsedJson['name'] != null ? parsedJson['name'] : '',
      showUsersPostsPageProfileImage: parsedJson['profileImage'] != null ? parsedJson['profileImage'] : '',
      showUsersPostsPageRelationship: parsedJson['relationship'] != null ? parsedJson['relationship'] : '',
      showUsersPostsPagePageCreator: APIBLMShowUsersPostsExtendedPageCreator.fromJson(parsedJson['page_creator']),
      showUsersPostsPageFollower: parsedJson['follower'],
      showUsersPostsPageManage: parsedJson['manage'],
      showUsersPostsPageFamOrFriends: parsedJson['famOrFriends'],
      showUsersPostsPagePageType: parsedJson['page_type'] != null ? parsedJson['page_type'] : '',
    );
  }
}

class APIBLMShowUsersPostsExtendedPageCreator{
  int showUsersPostsPageCreatorId;

  APIBLMShowUsersPostsExtendedPageCreator({required this.showUsersPostsPageCreatorId});

  factory APIBLMShowUsersPostsExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowUsersPostsExtendedPageCreator(
      showUsersPostsPageCreatorId: parsedJson['id'],
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
      showUsersPostsTaggedFirstName: parsedJson['first_name'] != null ? parsedJson['first_name'] : '',
      showUsersPostsTaggedLastName: parsedJson['last_name'] != null ? parsedJson['last_name'] : '',
      showUsersPostsTaggedImage: parsedJson['image'] != null ? parsedJson['image'] : '',
    );
  }
}