import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularShowCommentOrReplyLikeStatus> apiRegularShowCommentOrReplyLikeStatus({required String commentableType, required int commentableId}) async{

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
      validateStatus: (status) {
        return status! < 600;
      },
      headers: <String, dynamic>{
        'access-token': getAccessToken!,
        'uid': getUID!,
        'client': getClient!,
      }
    ),
  );

  print('The status code of regular show comment or reply like status is ${response.statusCode}');

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
