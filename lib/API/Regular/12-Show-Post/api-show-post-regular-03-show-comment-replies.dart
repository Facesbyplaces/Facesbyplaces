import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularShowListOfReplies> apiRegularShowListOfReplies({required int postId, required int page}) async{

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

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/posts/index/replies/$postId?page=$page',
    options: Options(
      headers: <String, dynamic>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),
  );

  print('The status code of regular show comment replies is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIRegularShowListOfReplies.fromJson(newData);
  }else{
    throw Exception('Error occurred: ${response.statusMessage}');
  }
}

class APIRegularShowListOfReplies{
  int almItemsRemaining;
  List<APIRegularShowListOfRepliesExtended> almRepliesList;

  APIRegularShowListOfReplies({required this.almItemsRemaining, required this.almRepliesList});

  factory APIRegularShowListOfReplies.fromJson(Map<String, dynamic> parsedJson){

    var newList1 = parsedJson['replies'] as List;
    List<APIRegularShowListOfRepliesExtended> repliesList = newList1.map((i) => APIRegularShowListOfRepliesExtended.fromJson(i)).toList();

    return APIRegularShowListOfReplies(
      almItemsRemaining: parsedJson['itemsremaining'],
      almRepliesList: repliesList,
    );
  }
}

class APIRegularShowListOfRepliesExtended{
  int showListOfRepliesReplyId;
  int showListOfRepliesCommentId;
  APIRegularShowListOfRepliesExtendedUser showListOfRepliesUser;
  String showListOfRepliesReplyBody;
  String showListOfRepliesCreatedAt;

  APIRegularShowListOfRepliesExtended({required this.showListOfRepliesReplyId, required this.showListOfRepliesCommentId, required this.showListOfRepliesReplyBody, required this.showListOfRepliesUser, required this.showListOfRepliesCreatedAt});

  factory APIRegularShowListOfRepliesExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowListOfRepliesExtended(
      showListOfRepliesReplyId: parsedJson['id'],
      showListOfRepliesCommentId: parsedJson['comment_id'],
      showListOfRepliesUser: APIRegularShowListOfRepliesExtendedUser.fromJson(parsedJson['user']),
      showListOfRepliesReplyBody: parsedJson['body'] != null ? parsedJson['body'] : '',
      showListOfRepliesCreatedAt: parsedJson['created_at'] != null ? parsedJson['created_at'] : '',
    );
  }
}

class APIRegularShowListOfRepliesExtendedUser{
  int showListRepliesUserUserId;
  String showListRepliesUserFirstName;
  String showListRepliesUserLastName;
  String showListRepliesUserImage;
  int showListOfCommentsUserAccountType;

  APIRegularShowListOfRepliesExtendedUser({required this.showListRepliesUserUserId, required this.showListRepliesUserFirstName, required this.showListRepliesUserLastName, required this.showListRepliesUserImage, required this.showListOfCommentsUserAccountType});

  factory APIRegularShowListOfRepliesExtendedUser.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowListOfRepliesExtendedUser(
      showListRepliesUserUserId: parsedJson['id'],
      showListRepliesUserFirstName: parsedJson['first_name'] != null ? parsedJson['first_name'] : '',
      showListRepliesUserLastName: parsedJson['last_name'] != null ? parsedJson['last_name'] : '',
      showListRepliesUserImage: parsedJson['image'] != null ? parsedJson['image'] : '',
      showListOfCommentsUserAccountType: parsedJson['account_type'],
    );
  }
}