import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowListOfReplies> apiBLMShowListOfReplies({int postId, int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

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
    return APIBLMShowListOfReplies.fromJson(newValue);
  }else{
    throw Exception('Failed to get the replies.');
  }
}

class APIBLMShowListOfReplies{
  int blmItemsRemaining;
  List<APIBLMShowListOfRepliesExtended> blmRepliesList;

  APIBLMShowListOfReplies({this.blmItemsRemaining, this.blmRepliesList});

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

  APIBLMShowListOfRepliesExtended({this.showListRepliesReplyId, this.showListRepliesCommentId, this.showListRepliesReplyBody, this.showListRepliesUser, this.showListRepliesCreatedAt});

  factory APIBLMShowListOfRepliesExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowListOfRepliesExtended(
      showListRepliesReplyId: parsedJson['id'],
      showListRepliesCommentId: parsedJson['comment_id'],
      showListRepliesUser: APIBLMShowListOfRepliesExtendedUser.fromJson(parsedJson['user']),
      showListRepliesReplyBody: parsedJson['body'],
      showListRepliesCreatedAt: parsedJson['created_at'],
    );
  }
}

class APIBLMShowListOfRepliesExtendedUser{
  int showListRepliesUserUserId;
  String showListRepliesUserFirstName;
  String showListRepliesUserLastName;
  dynamic showListRepliesUserImage;

  APIBLMShowListOfRepliesExtendedUser({this.showListRepliesUserUserId, this.showListRepliesUserFirstName, this.showListRepliesUserLastName, this.showListRepliesUserImage});

  factory APIBLMShowListOfRepliesExtendedUser.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowListOfRepliesExtendedUser(
      showListRepliesUserUserId: parsedJson['id'],
      showListRepliesUserFirstName: parsedJson['first_name'],
      showListRepliesUserLastName: parsedJson['last_name'],
      showListRepliesUserImage: parsedJson['image'],
    );
  }
}