import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowListOfComments> apiBLMShowListOfComments({int postId, int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  print('The post id is $postId');
  print('The page is $page');

  final http.Response response = await http.get(
    'http://fbp.dev1.koda.ws/api/v1/posts/index/comments/$postId?page=$page',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The status code of comments is ${response.statusCode}');
  print('The status body of comments is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMShowListOfComments.fromJson(newValue);
  }else{
    throw Exception('Failed to get the lists.');
  }
}



class APIBLMShowListOfComments{
  int itemsRemaining;
  List<APIBLMShowListOfCommentsExtended> commentsList;

  APIBLMShowListOfComments({this.itemsRemaining, this.commentsList});

  factory APIBLMShowListOfComments.fromJson(Map<String, dynamic> parsedJson){

    var newList1 = parsedJson['comments'] as List;
    List<APIBLMShowListOfCommentsExtended> commentsList = newList1.map((i) => APIBLMShowListOfCommentsExtended.fromJson(i)).toList();

    return APIBLMShowListOfComments(
      itemsRemaining: parsedJson['itemsremaining'],
      commentsList: commentsList,
    );
  }
}


class APIBLMShowListOfCommentsExtended{
  int commentId;
  int postId;
  APIBLMShowListOfCommentsExtendedUser user;
  String commentBody;
  String createdAt;

  APIBLMShowListOfCommentsExtended({this.commentId, this.postId, this.commentBody, this.user, this.createdAt});

  factory APIBLMShowListOfCommentsExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowListOfCommentsExtended(
      commentId: parsedJson['id'],
      postId: parsedJson['post_id'],
      user: APIBLMShowListOfCommentsExtendedUser.fromJson(parsedJson['user']),
      commentBody: parsedJson['body'],
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