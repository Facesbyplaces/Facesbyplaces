import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowListOfComments> apiRegularShowListOfComments({required int postId, required int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get(
    Uri.http('http://fbp.dev1.koda.ws/api/v1/posts/index/comments/$postId?page=$page', ''),
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

  APIRegularShowListOfComments({required this.almItemsRemaining, required this.almCommentsList});

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

  APIRegularShowListOfCommentsExtended({required this.showListOfCommentsCommentId, required this.showListOfCommentsPostId, required this.showListOfCommentsCommentBody, required this.showListOfCommentsUser, required this.showListOfCommentsCreatedAt});

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
  int showListOfCommentsUserAccountType;

  APIRegularShowListOfCommentsExtendedUser({required this.showListOfCommentsUserId, required this.showListOfCommentsUserFirstName, required this.showListOfCommentsUserLastName, required this.showListOfCommentsUserImage, required this.showListOfCommentsUserAccountType});

  factory APIRegularShowListOfCommentsExtendedUser.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowListOfCommentsExtendedUser(
      showListOfCommentsUserId: parsedJson['id'],
      showListOfCommentsUserFirstName: parsedJson['first_name'],
      showListOfCommentsUserLastName: parsedJson['last_name'],
      showListOfCommentsUserImage: parsedJson['image'],
      showListOfCommentsUserAccountType: parsedJson['account_type'],
    );
  }
}