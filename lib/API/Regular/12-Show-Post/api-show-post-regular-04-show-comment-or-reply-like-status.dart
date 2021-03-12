import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularShowCommentOrReplyLikeStatus> apiRegularShowCommentOrReplyLikeStatus({required String commentableType, required int commentableId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/posts/comment/likeCommentStatus?commentable_type=$commentableType&commentable_id=$commentableId',
    options: Options(
      headers: <String, dynamic>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),
  );

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIRegularShowCommentOrReplyLikeStatus.fromJson(newData);
  }else{
    throw Exception('Error occurred: ${response.statusMessage}');
  }
}

class APIRegularShowCommentOrReplyLikeStatus{
  bool showCommentOrReplyLikeStatus;
  int showCommentOrReplyNumberOfLikes;

  APIRegularShowCommentOrReplyLikeStatus({required this.showCommentOrReplyLikeStatus, required this.showCommentOrReplyNumberOfLikes});

  factory APIRegularShowCommentOrReplyLikeStatus.fromJson(Map<String, dynamic> parsedJson){

    return APIRegularShowCommentOrReplyLikeStatus(
      showCommentOrReplyLikeStatus: parsedJson['like'],
      showCommentOrReplyNumberOfLikes: parsedJson['numberOfLikes'],
    );
  }
}
