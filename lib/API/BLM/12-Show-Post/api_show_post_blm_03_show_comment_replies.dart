import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIBLMShowListOfReplies> apiBLMShowListOfReplies({required int postId, required int page}) async{
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

  var response = await dioRequest.get('https://www.facesbyplaces.com/api/v1/posts/index/replies/$postId?page=$page',
    options: Options(
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      },
      validateStatus: (status){
        return status! < 600;
      },
      followRedirects: false,
    ),  
  );

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIBLMShowListOfReplies.fromJson(newData);
  }else{
    throw Exception('Failed to get the replies.');
  }
}

class APIBLMShowListOfReplies{
  int blmItemsRemaining;
  List<APIBLMShowListOfRepliesExtended> blmRepliesList;
  APIBLMShowListOfReplies({required this.blmItemsRemaining, required this.blmRepliesList});

  factory APIBLMShowListOfReplies.fromJson(Map<String, dynamic> parsedJson){
    var newList1 = parsedJson['replies'] as List;
    List<APIBLMShowListOfRepliesExtended> repliesList = newList1.map((i) => APIBLMShowListOfRepliesExtended.fromJson(i)).toList();

    return APIBLMShowListOfReplies(
      blmItemsRemaining: parsedJson['itemsremaining'],
      blmRepliesList: repliesList,
    );
  }
}

class APIBLMShowListOfRepliesExtended{
  int showListRepliesReplyId;
  int showListRepliesCommentId;
  APIBLMShowListOfRepliesExtendedUser showListRepliesUser;
  String showListRepliesReplyBody;
  String showListRepliesCreatedAt;
  APIBLMShowListOfRepliesExtended({required this.showListRepliesReplyId, required this.showListRepliesCommentId, required this.showListRepliesReplyBody, required this.showListRepliesUser, required this.showListRepliesCreatedAt});

  factory APIBLMShowListOfRepliesExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowListOfRepliesExtended(
      showListRepliesReplyId: parsedJson['id'],
      showListRepliesCommentId: parsedJson['comment_id'],
      showListRepliesUser: APIBLMShowListOfRepliesExtendedUser.fromJson(parsedJson['user']),
      showListRepliesReplyBody: parsedJson['body'] ?? '',
      showListRepliesCreatedAt: parsedJson['created_at'] ?? '',
    );
  }
}

class APIBLMShowListOfRepliesExtendedUser{
  int showListRepliesUserUserId;
  String showListRepliesUserFirstName;
  String showListRepliesUserLastName;
  String showListRepliesUserImage;
  int showListRepliesUserAccountType;
  APIBLMShowListOfRepliesExtendedUser({required this.showListRepliesUserUserId, required this.showListRepliesUserFirstName, required this.showListRepliesUserLastName, required this.showListRepliesUserImage, required this.showListRepliesUserAccountType});

  factory APIBLMShowListOfRepliesExtendedUser.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowListOfRepliesExtendedUser(
      showListRepliesUserUserId: parsedJson['id'],
      showListRepliesUserFirstName: parsedJson['first_name'] ?? '',
      showListRepliesUserLastName: parsedJson['last_name'] ?? '',
      showListRepliesUserImage: parsedJson['image'] ?? '',
      showListRepliesUserAccountType: parsedJson['account_type'],
    );
  }
}