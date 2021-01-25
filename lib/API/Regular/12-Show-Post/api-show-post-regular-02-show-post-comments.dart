import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowListOfComments> apiRegularShowListOfComments({int postId, int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/posts/index/comments/$postId?page=$page',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularShowListOfComments.fromJson(newValue);
  }else{
    throw Exception('Failed to get the lists.');
  }
}



class APIRegularShowListOfComments{
  int itemsRemaining;
  List<APIRegularShowListOfCommentsExtended> commentsList;

  APIRegularShowListOfComments({this.itemsRemaining, this.commentsList});

  factory APIRegularShowListOfComments.fromJson(Map<String, dynamic> parsedJson){

    var newList1 = parsedJson['comments'] as List;
    List<APIRegularShowListOfCommentsExtended> commentsList = newList1.map((i) => APIRegularShowListOfCommentsExtended.fromJson(i)).toList();

    return APIRegularShowListOfComments(
      itemsRemaining: parsedJson['itemsremaining'],
      commentsList: commentsList,
    );
  }
}


class APIRegularShowListOfCommentsExtended{
  int commentId;
  int postId;
  APIRegularShowListOfCommentsExtendedUser user;
  String commentBody;
  String createdAt;

  APIRegularShowListOfCommentsExtended({this.commentId, this.postId, this.commentBody, this.user, this.createdAt});

  factory APIRegularShowListOfCommentsExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowListOfCommentsExtended(
      commentId: parsedJson['id'],
      postId: parsedJson['post_id'],
      user: APIRegularShowListOfCommentsExtendedUser.fromJson(parsedJson['user']),
      commentBody: parsedJson['body'],
      createdAt: parsedJson['created_at'],
    );
  }
}

class APIRegularShowListOfCommentsExtendedUser{
  int userId;
  String firstName;
  String lastName;
  dynamic image;

  APIRegularShowListOfCommentsExtendedUser({this.userId, this.firstName, this.lastName, this.image});

  factory APIRegularShowListOfCommentsExtendedUser.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowListOfCommentsExtendedUser(
      userId: parsedJson['id'],
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      image: parsedJson['image'],
    );
  }
}