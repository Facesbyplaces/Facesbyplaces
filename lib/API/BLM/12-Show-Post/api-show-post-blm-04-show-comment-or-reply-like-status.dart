import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowCommentOrReplyLikeStatus> apiBLMShowCommentOrReplyLikeStatus({required String commentableType, required int commentableId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get(
    Uri.http('http://fbp.dev1.koda.ws/api/v1/posts/comment/likeCommentStatus?commentable_type=$commentableType&commentable_id=$commentableId', ''),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMShowCommentOrReplyLikeStatus.fromJson(newValue);
  }else{
    throw Exception('Failed to get the replies.');
  }
}

class APIBLMShowCommentOrReplyLikeStatus{
  bool showCommentOrReplyLikeStatus;
  int showCommentOrReplyNumberOfLikes;

  APIBLMShowCommentOrReplyLikeStatus({required this.showCommentOrReplyLikeStatus, required this.showCommentOrReplyNumberOfLikes});

  factory APIBLMShowCommentOrReplyLikeStatus.fromJson(Map<String, dynamic> parsedJson){

    return APIBLMShowCommentOrReplyLikeStatus(
      showCommentOrReplyLikeStatus: parsedJson['like'],
      showCommentOrReplyNumberOfLikes: parsedJson['numberOfLikes'],
    );
  }
}
