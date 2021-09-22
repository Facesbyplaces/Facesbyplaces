import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIBLMShowOriginalPostMain> apiBLMShowOriginalPost({required int postId}) async{
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

  var response = await dioRequest.get('http://facesbyplaces.com/api/v1/posts/$postId',
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
    return APIBLMShowOriginalPostMain.fromJson(newData);
  }else{
    throw Exception('Failed to get the post');
  }
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
  String showOriginalPostCreatedAt;
  int showOriginalPostNumberOfLikes;
  int showOriginalPostNumberOfComments;
  bool showOriginalPostLikeStatus;
  APIBLMShowOriginalPostExtended({required this.showOriginalPostId, required this.showOriginalPostPage, required this.showOriginalPostBody, required this.showOriginalPostLocation, required this.showOriginalPostLatitude, required this.showOriginalPostLongitude, required this.showOriginalPostImagesOrVideos, required this.showOriginalPostPostTagged, required this.showOriginalPostCreatedAt, required this.showOriginalPostNumberOfLikes, required this.showOriginalPostNumberOfComments, required this.showOriginalPostLikeStatus});

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
      showOriginalPostLocation: parsedJson['location'] ?? '',
      showOriginalPostLatitude: parsedJson['latitude'],
      showOriginalPostLongitude: parsedJson['longitude'],
      showOriginalPostImagesOrVideos: newList ?? [],
      showOriginalPostPostTagged: taggedList,
      showOriginalPostCreatedAt: parsedJson['created_at'],
      showOriginalPostNumberOfLikes: parsedJson['numberOfLikes'],
      showOriginalPostNumberOfComments: parsedJson['numberOfComments'],
      showOriginalPostLikeStatus: parsedJson['likeStatus'],
    );
  }
}

class APIBLMShowOriginalPostExtendedPage{
  int showOriginalPostPageId;
  String showOriginalPostPageName;
  String showOriginalPostPageProfileImage;
  String showOriginalPostPageRelationship;
  APIBLMShowOriginalPostExtendedPageCreator showOriginalPostPagePageCreator;
  bool showOriginalPostPageManage;
  bool showOriginalPostPageFamOrFriends;
  bool showOriginalPostPageFollower;
  String showOriginalPostPagePageType;
  APIBLMShowOriginalPostExtendedPage({required this.showOriginalPostPageId, required this.showOriginalPostPageName, required this.showOriginalPostPageProfileImage, required this.showOriginalPostPageRelationship, required this.showOriginalPostPagePageCreator, required this.showOriginalPostPageManage, required this.showOriginalPostPageFamOrFriends, required this.showOriginalPostPageFollower, required this.showOriginalPostPagePageType,});

  factory APIBLMShowOriginalPostExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowOriginalPostExtendedPage(
      showOriginalPostPageId: parsedJson['id'],
      showOriginalPostPageName: parsedJson['name'],
      showOriginalPostPageProfileImage: parsedJson['profileImage'],
      showOriginalPostPageRelationship: parsedJson['relationship'],
      showOriginalPostPagePageCreator: APIBLMShowOriginalPostExtendedPageCreator.fromJson(parsedJson['page_creator']),
      showOriginalPostPageManage: parsedJson['manage'],
      showOriginalPostPageFamOrFriends: parsedJson['famOrFriends'],
      showOriginalPostPageFollower: parsedJson['follower'],
      showOriginalPostPagePageType: parsedJson['page_type'],
    );
  }
}

class APIBLMShowOriginalPostExtendedPageCreator{
  int showOriginalPostPageCreatorAccountType;
  APIBLMShowOriginalPostExtendedPageCreator({required this.showOriginalPostPageCreatorAccountType});

  factory APIBLMShowOriginalPostExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowOriginalPostExtendedPageCreator(
      showOriginalPostPageCreatorAccountType: parsedJson['account_type'],
    );
  }
}

class APIBLMShowOriginalPostExtendedTagged{
  int showOriginalPostTaggedId;
  String showOriginalPostTaggedFirstName;
  String showOriginalPostTaggedLastName;
  int showOriginalPostAccountType;
  APIBLMShowOriginalPostExtendedTagged({required this.showOriginalPostTaggedId, required this.showOriginalPostTaggedFirstName, required this.showOriginalPostTaggedLastName, required this.showOriginalPostAccountType});

  factory APIBLMShowOriginalPostExtendedTagged.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowOriginalPostExtendedTagged(
      showOriginalPostTaggedId: parsedJson['id'],
      showOriginalPostTaggedFirstName: parsedJson['first_name'] ?? '',
      showOriginalPostTaggedLastName: parsedJson['last_name'] ?? '',
      showOriginalPostAccountType: parsedJson['account_type'],
    );
  }
}