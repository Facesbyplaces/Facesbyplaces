import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowListOfReplies> apiRegularShowListOfReplies({required int postId, required int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get(
    Uri.http('http://fbp.dev1.koda.ws/api/v1/posts/index/replies/$postId?page=$page', ''),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularShowListOfReplies.fromJson(newValue);
  }else{
    throw Exception('Failed to get the replies.');
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
      showListOfRepliesReplyBody: parsedJson['body'],
      showListOfRepliesCreatedAt: parsedJson['created_at'],
    );
  }
}

class APIRegularShowListOfRepliesExtendedUser{
  int showListRepliesUserUserId;
  String showListRepliesUserFirstName;
  String showListRepliesUserLastName;
  dynamic showListRepliesUserImage;
  int showListOfCommentsUserAccountType;

  APIRegularShowListOfRepliesExtendedUser({required this.showListRepliesUserUserId, required this.showListRepliesUserFirstName, required this.showListRepliesUserLastName, required this.showListRepliesUserImage, required this.showListOfCommentsUserAccountType});

  factory APIRegularShowListOfRepliesExtendedUser.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowListOfRepliesExtendedUser(
      showListRepliesUserUserId: parsedJson['id'],
      showListRepliesUserFirstName: parsedJson['first_name'],
      showListRepliesUserLastName: parsedJson['last_name'],
      showListRepliesUserImage: parsedJson['image'],
      showListOfCommentsUserAccountType: parsedJson['account_type'],
    );
  }
}