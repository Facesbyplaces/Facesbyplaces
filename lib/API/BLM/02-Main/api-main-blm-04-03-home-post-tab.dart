import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIBLMHomeTabPostMain> apiBLMHomePostTab({required int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/mainpages/posts/?page=$page',
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

  // print('The status code of blm home post tab is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIBLMHomeTabPostMain.fromJson(newData);
  }else{
    throw Exception('Failed to get the post');
  }
}

class APIBLMHomeTabPostMain{
  int blmItemsRemaining;
  List<APIBLMHomeTabPostExtended> blmFamilyMemorialList;

  APIBLMHomeTabPostMain({required this.blmItemsRemaining, required this.blmFamilyMemorialList});

  factory APIBLMHomeTabPostMain.fromJson(Map<String, dynamic> parsedJson){
    var newList = parsedJson['posts'] as List;
    List<APIBLMHomeTabPostExtended> familyMemorials = newList.map((i) => APIBLMHomeTabPostExtended.fromJson(i)).toList();

    return APIBLMHomeTabPostMain(
      blmItemsRemaining: parsedJson['itemsremaining'],
      blmFamilyMemorialList: familyMemorials,
    );
  }
}

class APIBLMHomeTabPostExtended{
  int homeTabPostId;
  APIBLMHomeTabPostExtendedPage homeTabPostPage;
  String homeTabPostBody;
  List<dynamic> homeTabPostImagesOrVideos;
  List<APIBLMHomeTabPostExtendedTagged> homeTabPostPostTagged;
  String homeTabPostCreatedAt;
  int homeTabPostNumberOfLikes;
  int homeTabPostNumberOfComments;
  bool homeTabPostLikeStatus;

  APIBLMHomeTabPostExtended({required this.homeTabPostId, required this.homeTabPostPage, required this.homeTabPostBody, required this.homeTabPostImagesOrVideos, required this.homeTabPostPostTagged, required this.homeTabPostCreatedAt, required this.homeTabPostNumberOfLikes, required this.homeTabPostNumberOfComments, required this.homeTabPostLikeStatus});

  factory APIBLMHomeTabPostExtended.fromJson(Map<String, dynamic> parsedJson){
    
    List<dynamic>? newList1;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList1 = List<dynamic>.from(list);
    }

    var newList2 = parsedJson['tag_people'] as List;
    List<APIBLMHomeTabPostExtendedTagged> taggedList = newList2.map((i) => APIBLMHomeTabPostExtendedTagged.fromJson(i)).toList();
    
    return APIBLMHomeTabPostExtended(
      homeTabPostId: parsedJson['id'],
      homeTabPostPage: APIBLMHomeTabPostExtendedPage.fromJson(parsedJson['page']),
      homeTabPostBody: parsedJson['body'] != null ? parsedJson['body'] : '',
      homeTabPostImagesOrVideos: newList1 != null ? newList1 : [],
      homeTabPostPostTagged: taggedList,
      homeTabPostCreatedAt: parsedJson['created_at'] != null ? parsedJson['created_at'] : '',
      homeTabPostNumberOfLikes: parsedJson['numberOfLikes'],
      homeTabPostNumberOfComments: parsedJson['numberOfComments'],
      homeTabPostLikeStatus: parsedJson['likeStatus'],
    );
  }
}

class APIBLMHomeTabPostExtendedPage{
  int homeTabPostPageId;
  String homeTabPostPageName;
  String homeTabPostPageProfileImage;
  String homeTabPostPageRelationship;
  APIBLMHomeTabPostExtendedPageCreator homeTabPostPagePageCreator;
  bool homeTabPostPageManage;
  bool homeTabPostPageFamOrFriends;
  bool homeTabPostPageFollower;
  String homeTabPostPagePageType;

  APIBLMHomeTabPostExtendedPage({required this.homeTabPostPageId, required this.homeTabPostPageName, required this.homeTabPostPageProfileImage, required this.homeTabPostPageRelationship, required this.homeTabPostPagePageCreator, required this.homeTabPostPageManage, required this.homeTabPostPageFamOrFriends, required this.homeTabPostPageFollower, required this.homeTabPostPagePageType,});

  factory APIBLMHomeTabPostExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeTabPostExtendedPage(
      homeTabPostPageId: parsedJson['id'],
      homeTabPostPageName: parsedJson['name'] != null ? parsedJson['name'] : '',
      homeTabPostPageProfileImage: parsedJson['profileImage'] != null ? parsedJson['profileImage'] : '',
      homeTabPostPageRelationship: parsedJson['relationship'] != null ? parsedJson['relationship'] : '',
      homeTabPostPagePageCreator: APIBLMHomeTabPostExtendedPageCreator.fromJson(parsedJson['page_creator']),
      homeTabPostPageManage: parsedJson['manage'],
      homeTabPostPageFamOrFriends: parsedJson['famOrFriends'],
      homeTabPostPageFollower: parsedJson['follower'],
      homeTabPostPagePageType: parsedJson['page_type'] != null ? parsedJson['page_type'] : '',
    );
  }
}

class APIBLMHomeTabPostExtendedPageCreator{
  int homeTabPostPageCreatorId;

  APIBLMHomeTabPostExtendedPageCreator({required this.homeTabPostPageCreatorId});

  factory APIBLMHomeTabPostExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeTabPostExtendedPageCreator(
      homeTabPostPageCreatorId: parsedJson['id'],
    );
  }
}

class APIBLMHomeTabPostExtendedTagged{
  int homeTabPostTabTaggedId;
  String homeTabPostTabTaggedFirstName;
  String homeTabPostTabTaggedLastName;
  String homeTabPostTabTaggedImage;

  APIBLMHomeTabPostExtendedTagged({required this.homeTabPostTabTaggedId, required this.homeTabPostTabTaggedFirstName, required this.homeTabPostTabTaggedLastName, required this.homeTabPostTabTaggedImage});

  factory APIBLMHomeTabPostExtendedTagged.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeTabPostExtendedTagged(
      homeTabPostTabTaggedId: parsedJson['id'],
      homeTabPostTabTaggedFirstName: parsedJson['first_name'] != null ? parsedJson['first_name'] : '',
      homeTabPostTabTaggedLastName: parsedJson['last_name'] != null ? parsedJson['last_name'] : '',
      homeTabPostTabTaggedImage: parsedJson['image'] != null ? parsedJson['image'] : '',
    );
  }
}