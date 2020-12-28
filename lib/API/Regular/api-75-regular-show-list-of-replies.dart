import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowListOfReplies> apiRegularShowListOfReplies({int commentId, int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  print('The page is $page');

  final http.Response response = await http.get(
    'http://fbp.dev1.koda.ws/api/v1/posts/index/replies/$commentId?page=$page',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The status code of replies is ${response.statusCode}');
  print('The status body of replies is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularShowListOfReplies.fromJson(newValue);
  }else{
    throw Exception('Failed to get the lists.');
  }
}



class APIRegularShowListOfReplies{
  int itemsRemaining;
  List<APIRegularShowListOfRepliesExtended> commentsList;

  APIRegularShowListOfReplies({this.itemsRemaining, this.commentsList});

  factory APIRegularShowListOfReplies.fromJson(Map<String, dynamic> parsedJson){

    var newList1 = parsedJson['replies'] as List;
    List<APIRegularShowListOfRepliesExtended> commentsList = newList1.map((i) => APIRegularShowListOfRepliesExtended.fromJson(i)).toList();

    return APIRegularShowListOfReplies(
      itemsRemaining: parsedJson['itemsremaining'],
      commentsList: commentsList,
    );
  }
}


class APIRegularShowListOfRepliesExtended{
  int replyId;
  int commentId;
  APIRegularShowListOfRepliesExtendedUser user;
  String commentBody;
  String createdAt;

  APIRegularShowListOfRepliesExtended({this.replyId, this.commentId, this.commentBody, this.user, this.createdAt});

  factory APIRegularShowListOfRepliesExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowListOfRepliesExtended(
      replyId: parsedJson['id'],
      commentId: parsedJson['comment_id'],
      user: APIRegularShowListOfRepliesExtendedUser.fromJson(parsedJson['user']),
      commentBody: parsedJson['body'],
      createdAt: parsedJson['created_at'],
    );
  }
}

class APIRegularShowListOfRepliesExtendedUser{
  int userId;
  String firstName;
  String lastName;
  dynamic image;

  APIRegularShowListOfRepliesExtendedUser({this.userId, this.firstName, this.lastName, this.image});

  factory APIRegularShowListOfRepliesExtendedUser.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowListOfRepliesExtendedUser(
      userId: parsedJson['id'],
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      image: parsedJson['image'],
    );
  }
}