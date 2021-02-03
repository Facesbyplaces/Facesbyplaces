import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowListOfComments> apiBLMShowListOfComments({int postId, int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

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
    return APIBLMShowListOfComments.fromJson(newValue);
  }else{
    throw Exception('Failed to get the comments.');
  }
}



class APIBLMShowListOfComments{
  int bmlItemsRemaining;
  List<APIBLMShowListOfCommentsExtended> bmlCommentsList;

  APIBLMShowListOfComments({this.bmlItemsRemaining, this.bmlCommentsList});

  factory APIBLMShowListOfComments.fromJson(Map<String, dynamic> parsedJson){

    var newList1 = parsedJson['comments'] as List;
    List<APIBLMShowListOfCommentsExtended> commentsList = newList1.map((i) => APIBLMShowListOfCommentsExtended.fromJson(i)).toList();

    return APIBLMShowListOfComments(
      bmlItemsRemaining: parsedJson['itemsremaining'],
      bmlCommentsList: commentsList,
    );
  }
}


class APIBLMShowListOfCommentsExtended{
  int showListCommentsCommentId;
  int showListCommentsPostId;
  APIBLMShowListOfCommentsExtendedUser showListCommentsUser;
  String showListCommentsCommentBody;
  String showListCommentsCreatedAt;

  APIBLMShowListOfCommentsExtended({this.showListCommentsCommentId, this.showListCommentsPostId, this.showListCommentsCommentBody, this.showListCommentsUser, this.showListCommentsCreatedAt});

  factory APIBLMShowListOfCommentsExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowListOfCommentsExtended(
      showListCommentsCommentId: parsedJson['id'],
      showListCommentsPostId: parsedJson['post_id'],
      showListCommentsUser: APIBLMShowListOfCommentsExtendedUser.fromJson(parsedJson['user']),
      showListCommentsCommentBody: parsedJson['body'],
      showListCommentsCreatedAt: parsedJson['created_at'],
    );
  }
}

class APIBLMShowListOfCommentsExtendedUser{
  int showListCommentsUserUserId;
  String showListCommentsUserFirstName;
  String showListCommentsUserLastName;
  dynamic showListCommentsUserImage;

  APIBLMShowListOfCommentsExtendedUser({this.showListCommentsUserUserId, this.showListCommentsUserFirstName, this.showListCommentsUserLastName, this.showListCommentsUserImage});

  factory APIBLMShowListOfCommentsExtendedUser.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowListOfCommentsExtendedUser(
      showListCommentsUserUserId: parsedJson['id'],
      showListCommentsUserFirstName: parsedJson['first_name'],
      showListCommentsUserLastName: parsedJson['last_name'],
      showListCommentsUserImage: parsedJson['image'],
    );
  }
}