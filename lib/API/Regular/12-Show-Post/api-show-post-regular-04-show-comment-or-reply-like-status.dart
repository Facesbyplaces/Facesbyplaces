import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowCommentOrReplyLikeStatus> apiRegularShowCommentOrReplyLikeStatus({String commentableType, int commentableId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/posts/comment/likeCommentStatus?commentable_type=$commentableType&commentable_id=$commentableId',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularShowCommentOrReplyLikeStatus.fromJson(newValue);
  }else{
    throw Exception('Failed to get the replies.');
  }
}

class APIRegularShowCommentOrReplyLikeStatus{
  bool likeStatus;
  int numberOfLikes;

  APIRegularShowCommentOrReplyLikeStatus({this.likeStatus, this.numberOfLikes});

  factory APIRegularShowCommentOrReplyLikeStatus.fromJson(Map<String, dynamic> parsedJson){

    return APIRegularShowCommentOrReplyLikeStatus(
      likeStatus: parsedJson['like'],
      numberOfLikes: parsedJson['numberOfLikes'],
    );
  }
}