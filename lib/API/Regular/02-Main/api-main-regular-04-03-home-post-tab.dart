import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularHomeTabPostMain> apiRegularHomePostTab({required int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/mainpages/posts/?page=$page',
    options: Options(
      followRedirects: false,
      validateStatus: (status) {
        return status! < 600;
      },
      headers: <String, dynamic>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),
  );

  print('The status code of regular home post tab is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIRegularHomeTabPostMain.fromJson(newData);
  }else{
    throw Exception('Error occurred in main page - post: ${response.statusMessage}');
  }
}

class APIRegularHomeTabPostMain{
  int almItemsRemaining;
  List<APIRegularHomeTabPostExtended> familyMemorialList;

  APIRegularHomeTabPostMain({required this.almItemsRemaining, required this.familyMemorialList});

  factory APIRegularHomeTabPostMain.fromJson(Map<String, dynamic> parsedJson){
    var newList = parsedJson['posts'] as List;
    List<APIRegularHomeTabPostExtended> familyMemorials = newList.map((i) => APIRegularHomeTabPostExtended.fromJson(i)).toList();

    return APIRegularHomeTabPostMain(
      almItemsRemaining: parsedJson['itemsremaining'],
      familyMemorialList: familyMemorials,
    );
  }
}

class APIRegularHomeTabPostExtended{
  int homeTabPostId;
  APIRegularHomeTabPostExtendedPage homeTabPostPage;
  String homeTabPostBody;
  List<dynamic> homeTabPostImagesOrVideos;
  List<APIRegularHomeTabPostExtendedTagged> homeTabPostPostTagged;
  String homeTabPostCreatedAt;
  int homeTabPostNumberOfLikes;
  int homeTabPostNumberOfComments;
  bool homeTabPostLikeStatus;

  APIRegularHomeTabPostExtended({required this.homeTabPostId, required this.homeTabPostPage, required this.homeTabPostBody, required this.homeTabPostImagesOrVideos, required this.homeTabPostPostTagged, required this.homeTabPostCreatedAt, required this.homeTabPostNumberOfLikes, required this.homeTabPostNumberOfComments, required this.homeTabPostLikeStatus});

  factory APIRegularHomeTabPostExtended.fromJson(Map<String, dynamic> parsedJson){
    
    List<dynamic>? newList1;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList1 = List<dynamic>.from(list);
    }

    var newList2 = parsedJson['tag_people'] as List;
    List<APIRegularHomeTabPostExtendedTagged> taggedList = newList2.map((i) => APIRegularHomeTabPostExtendedTagged.fromJson(i)).toList();    
    
    return APIRegularHomeTabPostExtended(
      homeTabPostId: parsedJson['id'],
      homeTabPostPage: APIRegularHomeTabPostExtendedPage.fromJson(parsedJson['page']),
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

class APIRegularHomeTabPostExtendedPage{
  int homeTabPostPageId;
  String homeTabPostPageName;
  String homeTabPostPageProfileImage;
  String homeTabPostPageRelationship;
  APIRegularHomeTabPostExtendedPageCreator homeTabPostPagePageCreator;
  bool homeTabPostPageManage;
  bool homeTabPostPageFamOrFriends;
  bool homeTabPostPageFollower;
  String homeTabPostPagePageType;

  APIRegularHomeTabPostExtendedPage({required this.homeTabPostPageId, required this.homeTabPostPageName, required this.homeTabPostPageProfileImage, required this.homeTabPostPageRelationship, required this.homeTabPostPagePageCreator, required this.homeTabPostPageManage, required this.homeTabPostPageFamOrFriends, required this.homeTabPostPageFollower, required this.homeTabPostPagePageType});

  factory APIRegularHomeTabPostExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeTabPostExtendedPage(
      homeTabPostPageId: parsedJson['id'],
      homeTabPostPageName: parsedJson['name'] != null ? parsedJson['name'] : '',
      homeTabPostPageProfileImage: parsedJson['profileImage'] != null ? parsedJson['profileImage'] : '',
      homeTabPostPageRelationship: parsedJson['relationship'] != null ? parsedJson['relationship'] : '',
      homeTabPostPagePageCreator: APIRegularHomeTabPostExtendedPageCreator.fromJson(parsedJson['page_creator']),
      homeTabPostPageManage: parsedJson['manage'],
      homeTabPostPageFamOrFriends: parsedJson['famOrFriends'],
      homeTabPostPageFollower: parsedJson['follower'],
      homeTabPostPagePageType: parsedJson['page_type'] != null ? parsedJson['page_type'] : '',
    );
  }
}

class APIRegularHomeTabPostExtendedPageCreator{
  int homeTabPostPageCreatorId;

  APIRegularHomeTabPostExtendedPageCreator({required this.homeTabPostPageCreatorId});

  factory APIRegularHomeTabPostExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeTabPostExtendedPageCreator(
      homeTabPostPageCreatorId: parsedJson['id'],
    );
  }
}

class APIRegularHomeTabPostExtendedTagged{
  int homeTabPostTabTaggedId;
  String homeTabPostTabTaggedFirstName;
  String homeTabPostTabTaggedLastName;
  String homeTabPostTabTaggedImage;

  APIRegularHomeTabPostExtendedTagged({required this.homeTabPostTabTaggedId, required this.homeTabPostTabTaggedFirstName, required this.homeTabPostTabTaggedLastName, required this.homeTabPostTabTaggedImage});

  factory APIRegularHomeTabPostExtendedTagged.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeTabPostExtendedTagged(
      homeTabPostTabTaggedId: parsedJson['id'],
      homeTabPostTabTaggedFirstName: parsedJson['first_name'] != null ? parsedJson['first_name'] : '',
      homeTabPostTabTaggedLastName: parsedJson['last_name'] != null ? parsedJson['last_name'] : '',
      homeTabPostTabTaggedImage: parsedJson['image'] != null ? parsedJson['image'] : '',
    );
  }
}