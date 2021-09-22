import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIBLMSearchPostMain> apiBLMSearchPosts({required String keywords, required int page}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://facesbyplaces.com/api/v1/search/posts?page=$page&keywords=$keywords',
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
    return APIBLMSearchPostMain.fromJson(newData);
  }else{
    throw Exception('Failed to get the posts');
  }
}

class APIBLMSearchPostMain{
  int blmItemsRemaining;
  List<APIBLMSearchPostExtended> blmSearchPostList;
  APIBLMSearchPostMain({required this.blmItemsRemaining, required this.blmSearchPostList});

  factory APIBLMSearchPostMain.fromJson(Map<String, dynamic> parsedJson){
    var newList = parsedJson['posts'] as List;
    List<APIBLMSearchPostExtended> familyMemorials = newList.map((i) => APIBLMSearchPostExtended.fromJson(i)).toList();
    
    return APIBLMSearchPostMain(
      blmItemsRemaining: parsedJson['itemsremaining'],
      blmSearchPostList: familyMemorials,
    );
  }
}

class APIBLMSearchPostExtended{
  int searchPostPostId;
  APIBLMSearchPostExtendedPage searchPostPage;
  String searchPostBody;
  String searchPostLocation;
  double searchPostLatitude;
  double searchPostLongitude;
  List<dynamic> searchPostImagesOrVideos;
  List<APIBLMSearchPostExtendedTagged> searchPostPostTagged;
  String searchPostCreatedAt;
  int searchPostNumberOfLikes;
  int searchPostNumberOfComments;
  bool searchPostLikeStatus;
  APIBLMSearchPostExtended({required this.searchPostPostId, required this.searchPostPage, required this.searchPostBody, required this.searchPostLocation, required this.searchPostLatitude, required this.searchPostLongitude, required this.searchPostImagesOrVideos, required this.searchPostPostTagged, required this.searchPostCreatedAt, required this.searchPostNumberOfLikes, required this.searchPostNumberOfComments, required this.searchPostLikeStatus});

  factory APIBLMSearchPostExtended.fromJson(Map<String, dynamic> parsedJson){
    List<dynamic>? newList1;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList1 = List<dynamic>.from(list);
    }

    var newList2 = parsedJson['tag_people'] as List;
    List<APIBLMSearchPostExtendedTagged> taggedList = newList2.map((i) => APIBLMSearchPostExtendedTagged.fromJson(i)).toList();
    
    return APIBLMSearchPostExtended(
      searchPostPostId: parsedJson['id'],
      searchPostPage: APIBLMSearchPostExtendedPage.fromJson(parsedJson['page']),
      searchPostBody: parsedJson['body'] ?? '',
      searchPostLocation: parsedJson['location'] ?? '',
      searchPostLatitude: parsedJson['latitude'],
      searchPostLongitude: parsedJson['longitude'],
      searchPostImagesOrVideos: newList1 ?? [],
      searchPostPostTagged: taggedList,
      searchPostCreatedAt: parsedJson['created_at'] ?? '',
      searchPostNumberOfLikes: parsedJson['numberOfLikes'],
      searchPostNumberOfComments: parsedJson['numberOfComments'],
      searchPostLikeStatus: parsedJson['likeStatus'],
    );
  }
}

class APIBLMSearchPostExtendedPage{
  int searchPostPagePageId;
  String searchPostPageName;
  String searchPostPageProfileImage;
  String searchPostPageRelationship;
  APIBLMSearchPostExtendedPageCreator searchPostPagePageCreator;
  bool searchPostPageManage;
  bool searchPostPageFamOrFriends;
  bool searchPostPageFollower;
  String searchPostPagePageType;
  APIBLMSearchPostExtendedPage({required this.searchPostPagePageId, required this.searchPostPageName, required this.searchPostPageProfileImage, required this.searchPostPageRelationship, required this.searchPostPagePageCreator, required this.searchPostPageManage, required this.searchPostPageFamOrFriends, required this.searchPostPageFollower, required this.searchPostPagePageType});

  factory APIBLMSearchPostExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMSearchPostExtendedPage(
      searchPostPagePageId: parsedJson['id'],
      searchPostPageName: parsedJson['name'],
      searchPostPageProfileImage: parsedJson['profileImage'] ?? '',
      searchPostPageRelationship: parsedJson['relationship'] ?? '',
      searchPostPagePageCreator: APIBLMSearchPostExtendedPageCreator.fromJson(parsedJson['page_creator']),
      searchPostPageManage: parsedJson['manage'],
      searchPostPageFamOrFriends: parsedJson['famOrFriends'],
      searchPostPageFollower: parsedJson['follower'],
      searchPostPagePageType: parsedJson['page_type'] ?? '',
    );
  }
}

class APIBLMSearchPostExtendedPageCreator{
  int searchPostPageCreatorCreatorId;
  APIBLMSearchPostExtendedPageCreator({required this.searchPostPageCreatorCreatorId});

  factory APIBLMSearchPostExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMSearchPostExtendedPageCreator(
      searchPostPageCreatorCreatorId: parsedJson['id'],
    );
  }
}

class APIBLMSearchPostExtendedTagged{
  int searchPostTaggedId;
  String searchPostTaggedFirstName;
  String searchPostTaggedLastName;
  String searchPostTaggedImage;
  APIBLMSearchPostExtendedTagged({required this.searchPostTaggedId, required this.searchPostTaggedFirstName, required this.searchPostTaggedLastName, required this.searchPostTaggedImage});

  factory APIBLMSearchPostExtendedTagged.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMSearchPostExtendedTagged(
      searchPostTaggedId: parsedJson['id'],
      searchPostTaggedFirstName: parsedJson['first_name'] ?? '',
      searchPostTaggedLastName: parsedJson['last_name'] ?? '',
      searchPostTaggedImage: parsedJson['image'] ?? '',
    );
  }
}