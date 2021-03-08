import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowListOfComments> apiBLMShowListOfComments({required int postId, required int page}) async{

  print('The post id is $postId');

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

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
    return APIBLMShowListOfComments.fromJson(newValue);
  }else{
    throw Exception('Failed to get the comments.');
  }
}

class APIBLMShowListOfComments{
  int blmItemsRemaining;
  List<APIBLMShowListOfCommentsExtended> blmCommentsList;

  APIBLMShowListOfComments({required this.blmItemsRemaining, required this.blmCommentsList});

  factory APIBLMShowListOfComments.fromJson(Map<String, dynamic> parsedJson){

    var newList1 = parsedJson['comments'] as List;
    List<APIBLMShowListOfCommentsExtended> commentsList = newList1.map((i) => APIBLMShowListOfCommentsExtended.fromJson(i)).toList();

    return APIBLMShowListOfComments(
      blmItemsRemaining: parsedJson['itemsremaining'],
      blmCommentsList: commentsList,
    );
  }
}

class APIBLMShowListOfCommentsExtended{
  int showListCommentsCommentId;
  int showListCommentsPostId;
  APIBLMShowListOfCommentsExtendedUser showListCommentsUser;
  String showListCommentsCommentBody;
  String showListCommentsCreatedAt;

  APIBLMShowListOfCommentsExtended({required this.showListCommentsCommentId, required this.showListCommentsPostId, required this.showListCommentsCommentBody, required this.showListCommentsUser, required this.showListCommentsCreatedAt});

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
  int showListCommentsUserAccountType;

  APIBLMShowListOfCommentsExtendedUser({required this.showListCommentsUserUserId, required this.showListCommentsUserFirstName, required this.showListCommentsUserLastName, required this.showListCommentsUserImage, required this.showListCommentsUserAccountType});

  factory APIBLMShowListOfCommentsExtendedUser.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowListOfCommentsExtendedUser(
      showListCommentsUserUserId: parsedJson['id'],
      showListCommentsUserFirstName: parsedJson['first_name'],
      showListCommentsUserLastName: parsedJson['last_name'],
      showListCommentsUserImage: parsedJson['image'],
      showListCommentsUserAccountType: parsedJson['account_type'],
    );
  }
}