import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIBLMShowCommentOrReplyLikeStatus> apiBLMShowCommentOrReplyLikeStatus({required String commentableType, required int commentableId}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  bool userSessionRegular = sharedPrefs.getBool('regular-user-session') ?? false;
  bool userSessionBLM = sharedPrefs.getBool('blm-user-session') ?? false;
  String? getAccessToken;
  String? getUID;
  String? getClient;

  if(userSessionRegular == true){
    getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
    getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
    getClient = sharedPrefs.getString('regular-client') ?? 'empty';
  }else if(userSessionBLM == true){
    getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
    getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
    getClient = sharedPrefs.getString('blm-client') ?? 'empty';
  }

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/posts/comment/likeCommentStatus?commentable_type=$commentableType&commentable_id=$commentableId',
    options: Options(
      followRedirects: false,
      validateStatus: (status){
        return status! < 600;
      },
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  print('The status code of blm show comments or reply like status is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIBLMShowCommentOrReplyLikeStatus.fromJson(newData);
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