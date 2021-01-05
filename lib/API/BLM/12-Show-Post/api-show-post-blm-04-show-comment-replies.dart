import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowListOfReplies> apiBLMShowListOfReplies({int postId, int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  print('The post id is $postId');
  print('The page is $page');

  final http.Response response = await http.get(
    // 'http://fbp.dev1.koda.ws/api/v1/posts/index/comments/$postId?page=$page',
    'http://fbp.dev1.koda.ws/api/v1/posts/index/replies/$postId?page=$page',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The status code of replies is ${response.statusCode}');
  // print('The status body of replies is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMShowListOfReplies.fromJson(newValue);
  }else{
    throw Exception('Failed to get the replies.');
  }
}



class APIBLMShowListOfReplies{
  int itemsRemaining;
  List<APIBLMShowListOfRepliesExtended> repliesList;

  APIBLMShowListOfReplies({this.itemsRemaining, this.repliesList});

  factory APIBLMShowListOfReplies.fromJson(Map<String, dynamic> parsedJson){

    var newList1 = parsedJson['replies'] as List;
    List<APIBLMShowListOfRepliesExtended> repliesList = newList1.map((i) => APIBLMShowListOfRepliesExtended.fromJson(i)).toList();

    return APIBLMShowListOfReplies(
      itemsRemaining: parsedJson['itemsremaining'],
      repliesList: repliesList,
    );
  }
}


class APIBLMShowListOfRepliesExtended{
  int replyId;
  int commentId;
  APIBLMShowListOfCommentsExtendedUser user;
  String replyBody;
  String createdAt;

  APIBLMShowListOfRepliesExtended({this.replyId, this.commentId, this.replyBody, this.user, this.createdAt});

  factory APIBLMShowListOfRepliesExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowListOfRepliesExtended(
      replyId: parsedJson['id'],
      commentId: parsedJson['comment_id'],
      user: APIBLMShowListOfCommentsExtendedUser.fromJson(parsedJson['user']),
      replyBody: parsedJson['body'],
      createdAt: parsedJson['created_at'],
    );
  }
}

class APIBLMShowListOfCommentsExtendedUser{
  int userId;
  String firstName;
  String lastName;
  dynamic image;

  APIBLMShowListOfCommentsExtendedUser({this.userId, this.firstName, this.lastName, this.image});

  factory APIBLMShowListOfCommentsExtendedUser.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowListOfCommentsExtendedUser(
      userId: parsedJson['id'],
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      image: parsedJson['image'],
    );
  }
}