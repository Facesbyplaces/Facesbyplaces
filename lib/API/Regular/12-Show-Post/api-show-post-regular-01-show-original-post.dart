import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularShowOriginalPostMain> apiRegularShowOriginalPost({required int postId}) async{

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

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/posts/$postId',
    options: Options(
      headers: <String, dynamic>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),
  );

  print('The status code of regular show original post is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIRegularShowOriginalPostMain.fromJson(newData);
  }else{
    throw Exception('Error occurred: ${response.statusMessage}');
  }
}

class APIRegularShowOriginalPostMain{
  APIRegularShowOriginalPostMainExtended almPost;

  APIRegularShowOriginalPostMain({required this.almPost});

  factory APIRegularShowOriginalPostMain.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowOriginalPostMain(
      almPost: APIRegularShowOriginalPostMainExtended.fromJson(parsedJson['post'])
    );
  }
}

class APIRegularShowOriginalPostMainExtended{
  APIRegularShowOriginalPostMainExtendedPage showOriginalPostPage;
  String showOriginalPostBody;
  List<dynamic> showOriginalPostImagesOrVideos;
  List<APIRegularShowOriginalPostExtendedTagged> showOriginalPostPostTagged;
  String showOriginalPostCreatedAt;
  int showOriginalPostNumberOfLikes;
  int showOriginalPostNumberOfComments;

  APIRegularShowOriginalPostMainExtended({required this.showOriginalPostPage, required this.showOriginalPostBody, required this.showOriginalPostImagesOrVideos, required this.showOriginalPostPostTagged, required this.showOriginalPostCreatedAt, required this.showOriginalPostNumberOfLikes, required this.showOriginalPostNumberOfComments});

  factory APIRegularShowOriginalPostMainExtended.fromJson(Map<String, dynamic> parsedJson){
    
    List<dynamic>? newList1;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList1 = List<dynamic>.from(list);
    }
    
    var newList2 = parsedJson['tag_people'] as List;
    List<APIRegularShowOriginalPostExtendedTagged> taggedList = newList2.map((i) => APIRegularShowOriginalPostExtendedTagged.fromJson(i)).toList();    

    return APIRegularShowOriginalPostMainExtended(
      showOriginalPostPage: APIRegularShowOriginalPostMainExtendedPage.fromJson(parsedJson['page']),
      showOriginalPostBody: parsedJson['body'] != null ? parsedJson['body'] : '',
      showOriginalPostImagesOrVideos: newList1 != null ? newList1 : [],
      showOriginalPostPostTagged: taggedList,
      showOriginalPostCreatedAt: parsedJson['created_at'] != null ? parsedJson['created_at'] : '',
      showOriginalPostNumberOfLikes: parsedJson['numberOfLikes'],
      showOriginalPostNumberOfComments: parsedJson['numberOfComments'],
    );
  }
}

class APIRegularShowOriginalPostMainExtendedPage{
  int showOriginalPostPageId;
  String showOriginalPostPageName;
  String showOriginalPostPageProfileImage;
  String showOriginalPostPageRelationship;
  APIRegularShowOriginalPostMainExtendedPageCreator showOriginalPostPagePageCreator;
  bool showOriginalPostPageManage;
  bool showOriginalPostPageFamOrFriends;
  bool showOriginalPostPageFollower;
  String showOriginalPostPagePageType;

  APIRegularShowOriginalPostMainExtendedPage({required this.showOriginalPostPageId, required this.showOriginalPostPageName, required this.showOriginalPostPageProfileImage, required this.showOriginalPostPageRelationship, required this.showOriginalPostPagePageCreator, required this.showOriginalPostPageManage, required this.showOriginalPostPageFamOrFriends, required this.showOriginalPostPageFollower, required this.showOriginalPostPagePageType,});

  factory APIRegularShowOriginalPostMainExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowOriginalPostMainExtendedPage(
      showOriginalPostPageId: parsedJson['id'],
      showOriginalPostPageName: parsedJson['name'] != null ? parsedJson['name'] : '',
      showOriginalPostPageProfileImage: parsedJson['profileImage'] != null ? parsedJson['profileImage'] : '',
      showOriginalPostPageRelationship: parsedJson['relationship'] != null ? parsedJson['relationship'] : '',
      showOriginalPostPagePageCreator: APIRegularShowOriginalPostMainExtendedPageCreator.fromJson(parsedJson['page_creator']),
      showOriginalPostPageManage: parsedJson['manage'],
      showOriginalPostPageFamOrFriends: parsedJson['famOrFriends'],
      showOriginalPostPageFollower: parsedJson['follower'],
      showOriginalPostPagePageType: parsedJson['page_type'] != null ? parsedJson['page_type'] : '',
    );
  }
}

class APIRegularShowOriginalPostMainExtendedPageCreator{
  int showOriginalPostPageCreatorAccountType;

  APIRegularShowOriginalPostMainExtendedPageCreator({required this.showOriginalPostPageCreatorAccountType});

  factory APIRegularShowOriginalPostMainExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowOriginalPostMainExtendedPageCreator(
      showOriginalPostPageCreatorAccountType: parsedJson['account_type'],
    );
  }
}

class APIRegularShowOriginalPostExtendedTagged{
  int showOriginalPostTaggedId;
  String showOriginalPostTaggedFirstName;
  String showOriginalPostTaggedLastName;

  APIRegularShowOriginalPostExtendedTagged({required this.showOriginalPostTaggedId, required this.showOriginalPostTaggedFirstName, required this.showOriginalPostTaggedLastName});

  factory APIRegularShowOriginalPostExtendedTagged.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowOriginalPostExtendedTagged(
      showOriginalPostTaggedId: parsedJson['id'],
      showOriginalPostTaggedFirstName: parsedJson['first_name'] != null ? parsedJson['first_name'] : '',
      showOriginalPostTaggedLastName: parsedJson['last_name'] != null ? parsedJson['last_name'] : '',
    );
  }
}