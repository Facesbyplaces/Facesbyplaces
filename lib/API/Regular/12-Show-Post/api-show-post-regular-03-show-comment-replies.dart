import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowListOfReplies> apiRegularShowListOfReplies({int postId, int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/posts/index/replies/$postId?page=$page',
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

  APIRegularShowListOfReplies({this.almItemsRemaining, this.almRepliesList});

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
  APIRegularShowListOfCommentsExtendedUser showListOfRepliesUser;
  String showListOfRepliesReplyBody;
  String showListOfRepliesCreatedAt;

  APIRegularShowListOfRepliesExtended({this.showListOfRepliesReplyId, this.showListOfRepliesCommentId, this.showListOfRepliesReplyBody, this.showListOfRepliesUser, this.showListOfRepliesCreatedAt});

  factory APIRegularShowListOfRepliesExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowListOfRepliesExtended(
      showListOfRepliesReplyId: parsedJson['id'],
      showListOfRepliesCommentId: parsedJson['comment_id'],
      showListOfRepliesUser: APIRegularShowListOfCommentsExtendedUser.fromJson(parsedJson['user']),
      showListOfRepliesReplyBody: parsedJson['body'],
      showListOfRepliesCreatedAt: parsedJson['created_at'],
    );
  }
}

class APIRegularShowListOfCommentsExtendedUser{
  int showListOfCommentsUserId;
  String showListOfCommentsUserFirstName;
  String showListOfCommentsUserLastName;
  dynamic showListOfCommentsUserImage;

  APIRegularShowListOfCommentsExtendedUser({this.showListOfCommentsUserId, this.showListOfCommentsUserFirstName, this.showListOfCommentsUserLastName, this.showListOfCommentsUserImage});

  factory APIRegularShowListOfCommentsExtendedUser.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowListOfCommentsExtendedUser(
      showListOfCommentsUserId: parsedJson['id'],
      showListOfCommentsUserFirstName: parsedJson['first_name'],
      showListOfCommentsUserLastName: parsedJson['last_name'],
      showListOfCommentsUserImage: parsedJson['image'],
    );
  }
}