import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIBLMShowListOfReplies> apiBLMShowListOfReplies({required int postId, required int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/posts/index/replies/$postId?page=$page',
    options: Options(
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  print('The status code of feed is ${response.statusCode}');

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
      showListRepliesReplyBody: parsedJson['body'] != null ? parsedJson['body'] : '',
      showListRepliesCreatedAt: parsedJson['created_at'] != null ? parsedJson['created_at'] : '',
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
      showListRepliesUserFirstName: parsedJson['first_name'] != null ? parsedJson['first_name'] : '',
      showListRepliesUserLastName: parsedJson['last_name'] != null ? parsedJson['last_name'] : '',
      showListRepliesUserImage: parsedJson['image'] != null ? parsedJson['image'] : '',
      showListRepliesUserAccountType: parsedJson['account_type'],
    );
  }
}