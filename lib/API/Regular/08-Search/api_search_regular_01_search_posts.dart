import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularSearchPostMain> apiRegularSearchPosts({required String keywords, required int page}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('https://facesbyplaces.com/api/v1/search/posts?page=$page&keywords=$keywords',
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

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIRegularSearchPostMain.fromJson(newData);
  }else{
    throw Exception('Failed to get the posts');
  }
}

class APIRegularSearchPostMain{
  int almItemsRemaining;
  List<APIRegularSearchPostExtended> almSearchPostList;
  APIRegularSearchPostMain({required this.almItemsRemaining, required this.almSearchPostList});

  factory APIRegularSearchPostMain.fromJson(Map<String, dynamic> parsedJson){
    var newList = parsedJson['posts'] as List;
    List<APIRegularSearchPostExtended> searchPostList = newList.map((i) => APIRegularSearchPostExtended.fromJson(i)).toList();

    return APIRegularSearchPostMain(
      almItemsRemaining: parsedJson['itemsremaining'],
      almSearchPostList: searchPostList,
    );
  }
}

class APIRegularSearchPostExtended{
  int searchPostId;
  APIRegularSearchPostExtendedPage searchPostPage;
  String searchPostBody;
  String searchPostLocation;
  double searchPostLatitude;
  double searchPostLongitude;
  List<dynamic> searchPostImagesOrVideos;
  List<APIRegularSearchPostExtendedTagged> searchPostPostTagged;
  String searchPostCreatedAt;
  int searchPostNumberOfLikes;
  int searchPostNumberOfComments;
  bool searchPostLikeStatus;
  APIRegularSearchPostExtended({required this.searchPostId, required this.searchPostPage, required this.searchPostBody, required this.searchPostLocation, required this.searchPostLatitude, required this.searchPostLongitude, required this.searchPostImagesOrVideos, required this.searchPostPostTagged, required this.searchPostCreatedAt, required this.searchPostNumberOfLikes, required this.searchPostNumberOfComments, required this.searchPostLikeStatus});

  factory APIRegularSearchPostExtended.fromJson(Map<String, dynamic> parsedJson){
    List<dynamic>? newList1;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList1 = List<dynamic>.from(list);
    }

    var newList2 = parsedJson['tag_people'] as List;
    List<APIRegularSearchPostExtendedTagged> taggedList = newList2.map((i) => APIRegularSearchPostExtendedTagged.fromJson(i)).toList();
    
    return APIRegularSearchPostExtended(
      searchPostId: parsedJson['id'],
      searchPostPage: APIRegularSearchPostExtendedPage.fromJson(parsedJson['page']),
      searchPostBody: parsedJson['body'],
      searchPostLocation: parsedJson['location'] ?? '',
      searchPostLatitude: parsedJson['latitude'],
      searchPostLongitude: parsedJson['longitude'],
      searchPostImagesOrVideos: newList1 ?? [],
      searchPostPostTagged: taggedList,
      searchPostCreatedAt: parsedJson['created_at'],
      searchPostNumberOfLikes: parsedJson['numberOfLikes'],
      searchPostNumberOfComments: parsedJson['numberOfComments'],
      searchPostLikeStatus: parsedJson['likeStatus'],
    );
  }
}

class APIRegularSearchPostExtendedPage{
  int searchPostPageId;
  String searchPostPageName;
  String searchPostPageProfileImage;
  String searchPostPageRelationship;
  APIRegularSearchPostExtendedPageCreator searchPostPagePageCreator;
  bool searchPostPageManage;
  bool searchPostPageFamOrFriends;
  bool searchPostPageFollower;
  String searchPostPagePageType;
  APIRegularSearchPostExtendedPage({required this.searchPostPageId, required this.searchPostPageName, required this.searchPostPageProfileImage, required this.searchPostPageRelationship, required this.searchPostPagePageCreator, required this.searchPostPageManage, required this.searchPostPageFamOrFriends, required this.searchPostPageFollower, required this.searchPostPagePageType,});

  factory APIRegularSearchPostExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularSearchPostExtendedPage(
      searchPostPageId: parsedJson['id'],
      searchPostPageName: parsedJson['name'] ?? '',
      searchPostPageProfileImage: parsedJson['profileImage'] ?? '',
      searchPostPageRelationship: parsedJson['relationship'] ?? '',
      searchPostPagePageCreator: APIRegularSearchPostExtendedPageCreator.fromJson(parsedJson['page_creator']),
      searchPostPageManage: parsedJson['manage'],
      searchPostPageFamOrFriends: parsedJson['famOrFriends'],
      searchPostPageFollower: parsedJson['follower'],
      searchPostPagePageType: parsedJson['page_type'] ?? '',
    );
  }
}

class APIRegularSearchPostExtendedPageCreator{
  int searchPostPageCreatorId;
  APIRegularSearchPostExtendedPageCreator({required this.searchPostPageCreatorId});

  factory APIRegularSearchPostExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularSearchPostExtendedPageCreator(
      searchPostPageCreatorId: parsedJson['id'],
    );
  }
}

class APIRegularSearchPostExtendedTagged{
  int searchPostTaggedId;
  String searchPostTaggedFirstName;
  String searchPostTaggedLastName;
  String searchPostTaggedImage;
  APIRegularSearchPostExtendedTagged({required this.searchPostTaggedId, required this.searchPostTaggedFirstName, required this.searchPostTaggedLastName, required this.searchPostTaggedImage});

  factory APIRegularSearchPostExtendedTagged.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularSearchPostExtendedTagged(
      searchPostTaggedId: parsedJson['id'],
      searchPostTaggedFirstName: parsedJson['first_name'] ?? '',
      searchPostTaggedLastName: parsedJson['last_name'] ?? '',
      searchPostTaggedImage: parsedJson['image'] ?? '',
    );
  }
}