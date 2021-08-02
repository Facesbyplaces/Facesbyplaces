import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIBLMHomeProfilePostMain> apiBLMProfilePost({required int memorialId, required int page}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/posts/page/Blm/$memorialId?page=$page',
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

  print('The status code of blm show profile post is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIBLMHomeProfilePostMain.fromJson(newData);
  }else{
    throw Exception('Failed to show profile posts');
  }
}

class APIBLMHomeProfilePostMain{
  int blmItemsRemaining;
  List<APIBLMHomeProfilePostExtended> blmFamilyMemorialList;
  APIBLMHomeProfilePostMain({required this.blmItemsRemaining, required this.blmFamilyMemorialList});

  factory APIBLMHomeProfilePostMain.fromJson(Map<String, dynamic> parsedJson){
    var newList = parsedJson['posts'] as List;
    List<APIBLMHomeProfilePostExtended> familyMemorials = newList.map((i) => APIBLMHomeProfilePostExtended.fromJson(i)).toList();

    return APIBLMHomeProfilePostMain(
      blmItemsRemaining: parsedJson['itemsremaining'],
      blmFamilyMemorialList: familyMemorials,
    );
  }
}

class APIBLMHomeProfilePostExtended{
  int profilePostId;
  APIBLMHomeProfilePostExtendedPage profilePostPage;
  String profilePostBody;
  String homeProfilePostLocation;
  double homeProfilePostLatitude;
  double homeProfilePostLongitude;
  List<dynamic> profilePostImagesOrVideos;
  List<APIBLMHomeProfilePostExtendedTagged> profilePostPostTagged;
  String profilePostCreatedAt;
  int profilePostNumberOfLikes;
  int profilePostNumberOfComments;
  bool profilePostLikeStatus;
  APIBLMHomeProfilePostExtended({required this.profilePostId, required this.profilePostPage, required this.profilePostBody, required this.homeProfilePostLocation, required this.homeProfilePostLatitude, required this.homeProfilePostLongitude, required this.profilePostImagesOrVideos, required this.profilePostPostTagged, required this.profilePostCreatedAt, required this.profilePostNumberOfLikes, required this.profilePostNumberOfComments, required this.profilePostLikeStatus});

  factory APIBLMHomeProfilePostExtended.fromJson(Map<String, dynamic> parsedJson){
    List<dynamic>? newList1;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList1 = List<dynamic>.from(list);
    }

    var newList2 = parsedJson['tag_people'] as List;
    List<APIBLMHomeProfilePostExtendedTagged> taggedList = newList2.map((i) => APIBLMHomeProfilePostExtendedTagged.fromJson(i)).toList();
    
    return APIBLMHomeProfilePostExtended(
      profilePostId: parsedJson['id'],
      profilePostPage: APIBLMHomeProfilePostExtendedPage.fromJson(parsedJson['page']),
      profilePostBody: parsedJson['body'] != null ? parsedJson['body'] : '',
      homeProfilePostLocation: parsedJson['location'] != null ? parsedJson['location'] : '',
      homeProfilePostLatitude: parsedJson['latitude'],
      homeProfilePostLongitude: parsedJson['longitude'],
      profilePostImagesOrVideos: newList1 != null ? newList1 : [],
      profilePostPostTagged: taggedList,
      profilePostCreatedAt: parsedJson['created_at'] != null ? parsedJson['created_at'] : '',
      profilePostNumberOfLikes: parsedJson['numberOfLikes'],
      profilePostNumberOfComments: parsedJson['numberOfComments'],
      profilePostLikeStatus: parsedJson['likeStatus'],
    );
  }
}

class APIBLMHomeProfilePostExtendedPage{
  int profilePageId;
  String profilePageName;
  String profilePageProfileImage;
  String profilePageRelationship;
  APIBLMHomeProfilePostExtendedPageCreator profilePagePageCreator;
  bool profilePageManage;
  bool profilePageFamOrFriends;
  bool profilePageFollower;
  String profilePagePageType;
  APIBLMHomeProfilePostExtendedPage({required this.profilePageId, required this.profilePageName, required this.profilePageProfileImage, required this.profilePageRelationship, required this.profilePagePageCreator, required this.profilePageManage, required this.profilePageFamOrFriends, required this.profilePageFollower, required this.profilePagePageType});

  factory APIBLMHomeProfilePostExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeProfilePostExtendedPage(
      profilePageId: parsedJson['id'],
      profilePageName: parsedJson['name'] != null ? parsedJson['name'] : '',
      profilePageProfileImage: parsedJson['profileImage'] != null ? parsedJson['profileImage'] : '',
      profilePageRelationship: parsedJson['relationship'] != null ? parsedJson['relationship'] : '',
      profilePagePageCreator: APIBLMHomeProfilePostExtendedPageCreator.fromJson(parsedJson['page_creator']),
      profilePageManage: parsedJson['manage'],
      profilePageFamOrFriends: parsedJson['famOrFriends'],
      profilePageFollower: parsedJson['follower'],
      profilePagePageType: parsedJson['page_type'] != null ? parsedJson['page_type'] : '',
    );
  }
}

class APIBLMHomeProfilePostExtendedPageCreator{
  int profilePageCreatorId;
  APIBLMHomeProfilePostExtendedPageCreator({required this.profilePageCreatorId});

  factory APIBLMHomeProfilePostExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeProfilePostExtendedPageCreator(
      profilePageCreatorId: parsedJson['id'],
    );
  }
}

class APIBLMHomeProfilePostExtendedTagged{
  int profilePageTaggedId;
  String profilePageTaggedFirstName;
  String profilePageTaggedLastName;
  String profilePageTaggedImage;
  APIBLMHomeProfilePostExtendedTagged({required this.profilePageTaggedId, required this.profilePageTaggedFirstName, required this.profilePageTaggedLastName, required this.profilePageTaggedImage});

  factory APIBLMHomeProfilePostExtendedTagged.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeProfilePostExtendedTagged(
      profilePageTaggedId: parsedJson['id'],
      profilePageTaggedFirstName: parsedJson['first_name'] != null ? parsedJson['first_name'] : '',
      profilePageTaggedLastName: parsedJson['last_name'] != null ? parsedJson['last_name'] : '',
      profilePageTaggedImage: parsedJson['image'] != null ? parsedJson['image'] : '',
    );
  }
}