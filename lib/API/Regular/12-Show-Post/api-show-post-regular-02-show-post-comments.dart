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
  int almItemsRemaining;
  List<APIRegularShowListOfCommentsExtended> almCommentsList;

  APIRegularShowListOfComments({this.almItemsRemaining, this.almCommentsList});

  factory APIRegularShowListOfComments.fromJson(Map<String, dynamic> parsedJson){

    var newList1 = parsedJson['comments'] as List;
    List<APIRegularShowListOfCommentsExtended> commentsList = newList1.map((i) => APIRegularShowListOfCommentsExtended.fromJson(i)).toList();

    return APIRegularShowListOfComments(
      almItemsRemaining: parsedJson['itemsremaining'],
      almCommentsList: commentsList,
    );
  }
}


class APIRegularShowListOfCommentsExtended{
  int showListOfCommentsCommentId;
  int showListOfCommentsPostId;
  APIRegularShowListOfCommentsExtendedUser showListOfCommentsUser;
  String showListOfCommentsCommentBody;
  String showListOfCommentsCreatedAt;

  APIRegularShowListOfCommentsExtended({this.showListOfCommentsCommentId, this.showListOfCommentsPostId, this.showListOfCommentsCommentBody, this.showListOfCommentsUser, this.showListOfCommentsCreatedAt});

  factory APIRegularShowListOfCommentsExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowListOfCommentsExtended(
      showListOfCommentsCommentId: parsedJson['id'],
      showListOfCommentsPostId: parsedJson['post_id'],
      showListOfCommentsUser: APIRegularShowListOfCommentsExtendedUser.fromJson(parsedJson['user']),
      showListOfCommentsCommentBody: parsedJson['body'],
      showListOfCommentsCreatedAt: parsedJson['created_at'],
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