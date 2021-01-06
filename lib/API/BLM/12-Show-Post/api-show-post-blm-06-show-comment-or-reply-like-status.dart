import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowCommentOrReplyLikeStatus> apiBLMShowCommentOrReplyLikeStatus({String commentableType, int commentableId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get(
    'http://fbp.dev1.koda.ws/api/v1/posts/comment/likeCommentStatus?commentable_type=$commentableType&commentable_id=$commentableId',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  // print('The status code of replies is ${response.statusCode}');
  // print('The status body of replies is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMShowCommentOrReplyLikeStatus.fromJson(newValue);
  }else{
    throw Exception('Failed to get the replies.');
  }
}



class APIBLMShowCommentOrReplyLikeStatus{
  bool likeStatus;
  int numberOfLikes;

  APIBLMShowCommentOrReplyLikeStatus({this.likeStatus, this.numberOfLikes});

  factory APIBLMShowCommentOrReplyLikeStatus.fromJson(Map<String, dynamic> parsedJson){

    return APIBLMShowCommentOrReplyLikeStatus(
      likeStatus: parsedJson['like'],
      numberOfLikes: parsedJson['numberOfLikes'],
    );
  }
}
