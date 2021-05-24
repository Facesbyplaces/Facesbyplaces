import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularShowUsersPostsMain> apiRegularShowUserPosts({required int userId, required int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  bool userSessionRegular = sharedPrefs.getBool('regular-user-session') ?? false;
  bool userSessionBLM = sharedPrefs.getBool('blm-user-session') ?? false;
  String? getAccessToken;
  String? getUID;
  String? getClient;

  if(userSessionRegular == true){
    getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
    getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
    getClient = sharedPrefs.getString('regular-client') ?? 'empty';
  }else if(userSessionBLM == true){
    getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
    getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
    getClient = sharedPrefs.getString('blm-client') ?? 'empty';
  }


  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/users/posts?user_id=$userId&page=$page',
    options: Options(
      followRedirects: false,
      validateStatus: (status) {
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

  print('The status code of regular show user posts is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIRegularShowUsersPostsMain.fromJson(newData);
  }else{
    throw Exception('Failed to get the posts');
  }
}

class APIRegularShowUsersPostsMain{
  int almItemsRemaining;
  List<APIRegularShowUsersPostsExtended> almFamilyMemorialList;

  APIRegularShowUsersPostsMain({required this.almItemsRemaining, required this.almFamilyMemorialList});

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
  List<dynamic> showUsersPostsImagesOrVideos;
  List<APIRegularShowUsersPostsExtendedTagged> showUsersPostsPostTagged;
  String showUsersPostsCreatedAt;
  int showUsersPostsNumberOfLikes;
  int showUsersPostsNumberOfComments;
  bool showUsersPostsLikeStatus;

  APIRegularShowUsersPostsExtended({required this.showUsersPostsId, required this.showUsersPostsPage, required this.showUsersPostsBody, required this.showUsersPostsImagesOrVideos, required this.showUsersPostsPostTagged, required this.showUsersPostsCreatedAt, required this.showUsersPostsNumberOfLikes, required this.showUsersPostsNumberOfComments, required this.showUsersPostsLikeStatus});

  factory APIRegularShowUsersPostsExtended.fromJson(Map<String, dynamic> parsedJson){
    
    List<dynamic>? newList1;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList1 = List<dynamic>.from(list);
    }

    var newList2 = parsedJson['tag_people'] as List;
    List<APIRegularShowUsersPostsExtendedTagged> taggedList = newList2.map((i) => APIRegularShowUsersPostsExtendedTagged.fromJson(i)).toList();
    
    return APIRegularShowUsersPostsExtended(
      showUsersPostsId: parsedJson['id'],
      showUsersPostsPage: APIRegularShowUsersPostsExtendedPage.fromJson(parsedJson['page']),
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

class APIRegularShowUsersPostsExtendedPage{
  int showUsersPostsPageId;
  String showUsersPostsPageName;
  String showUsersPostsPageProfileImage;
  String showUsersPostsPageRelationship;
  APIRegularShowUsersPostsExtendedPageCreator showUsersPostsPagePageCreator;
  bool showUsersPostsPageFollower;
  bool showUsersPostsPageManage;
  bool showUsersPostsPageFamOrFriends;
  String showUsersPostsPagePageType;

  APIRegularShowUsersPostsExtendedPage({required this.showUsersPostsPageId, required this.showUsersPostsPageName, required this.showUsersPostsPageProfileImage, required this.showUsersPostsPageRelationship, required this.showUsersPostsPagePageCreator, required this.showUsersPostsPageFollower, required this.showUsersPostsPageFamOrFriends, required this.showUsersPostsPageManage, required this.showUsersPostsPagePageType});

  factory APIRegularShowUsersPostsExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowUsersPostsExtendedPage(
      showUsersPostsPageId: parsedJson['id'],
      showUsersPostsPageName: parsedJson['name'] != null ? parsedJson['name'] : '',
      showUsersPostsPageProfileImage: parsedJson['profileImage'] != null ? parsedJson['profileImage'] : '',
      showUsersPostsPageRelationship: parsedJson['relationship'] != null ? parsedJson['relationship'] : '',
      showUsersPostsPagePageCreator: APIRegularShowUsersPostsExtendedPageCreator.fromJson(parsedJson['page_creator']),
      showUsersPostsPageFollower: parsedJson['follower'],
      showUsersPostsPageManage: parsedJson['manage'],
      showUsersPostsPageFamOrFriends: parsedJson['famOrFriends'],
      showUsersPostsPagePageType: parsedJson['page_type'] != null ? parsedJson['page_type'] : '',
    );
  }
}

class APIRegularShowUsersPostsExtendedPageCreator{
  int showUsersPostsPageCreatorId;

  APIRegularShowUsersPostsExtendedPageCreator({required this.showUsersPostsPageCreatorId});

  factory APIRegularShowUsersPostsExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowUsersPostsExtendedPageCreator(
      showUsersPostsPageCreatorId: parsedJson['id'],
    );
  }
}

class APIRegularShowUsersPostsExtendedTagged{
  int showUsersPostsTaggedId;
  String showUsersPostsTaggedFirstName;
  String showUsersPostsTaggedLastName;
  String showUsersPostsTaggedImage;

  APIRegularShowUsersPostsExtendedTagged({required this.showUsersPostsTaggedId, required this.showUsersPostsTaggedFirstName, required this.showUsersPostsTaggedLastName, required this.showUsersPostsTaggedImage});

  factory APIRegularShowUsersPostsExtendedTagged.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowUsersPostsExtendedTagged(
      showUsersPostsTaggedId: parsedJson['id'],
      showUsersPostsTaggedFirstName: parsedJson['first_name'] != null ? parsedJson['first_name'] : '',
      showUsersPostsTaggedLastName: parsedJson['last_name'] != null ? parsedJson['last_name'] : '',
      showUsersPostsTaggedImage: parsedJson['image'] != null ? parsedJson['image'] : '',
    );
  }
}