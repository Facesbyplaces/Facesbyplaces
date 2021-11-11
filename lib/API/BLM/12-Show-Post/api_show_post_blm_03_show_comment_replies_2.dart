import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIBLMShowListOfRepliesDuplicate> apiBLMShowListOfRepliesDuplicate({required int postId}) async{
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

  // var response = await dioRequest.get('https://facesbyplaces.com/api/v1/posts/index/replies2/$postId',
  var response = await dioRequest.get('https://www.facesbyplaces.com/api/v1/posts/index/replies2/$postId',
    options: Options(
      headers: <String, dynamic>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      },
      validateStatus: (status){
        return status! < 600;
      },
      followRedirects: false,
    ),
  );

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIBLMShowListOfRepliesDuplicate.fromJson(newData);
  }else{
    throw Exception('Error occurred: ${response.statusMessage}');
  }
}

class APIBLMShowListOfRepliesDuplicate{
  List<APIBLMShowListOfRepliesExtendedDuplicate> blmRepliesList;
  APIBLMShowListOfRepliesDuplicate({required this.blmRepliesList});

  factory APIBLMShowListOfRepliesDuplicate.fromJson(Map<String, dynamic> parsedJson){
    var newList1 = parsedJson['replies'] as List;
    List<APIBLMShowListOfRepliesExtendedDuplicate> repliesList = newList1.map((i) => APIBLMShowListOfRepliesExtendedDuplicate.fromJson(i)).toList();

    return APIBLMShowListOfRepliesDuplicate(
      blmRepliesList: repliesList,
    );
  }
}

class APIBLMShowListOfRepliesExtendedDuplicate{
  int showListOfRepliesReplyId;
  int showListOfRepliesCommentId;
  APIBLMShowListOfRepliesExtendedUserDuplicate showListOfRepliesUser;
  String showListOfRepliesReplyBody;
  String showListOfRepliesCreatedAt;
  APIBLMShowListOfRepliesExtendedDuplicate({required this.showListOfRepliesReplyId, required this.showListOfRepliesCommentId, required this.showListOfRepliesReplyBody, required this.showListOfRepliesUser, required this.showListOfRepliesCreatedAt});

  factory APIBLMShowListOfRepliesExtendedDuplicate.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowListOfRepliesExtendedDuplicate(
      showListOfRepliesReplyId: parsedJson['id'],
      showListOfRepliesCommentId: parsedJson['comment_id'],
      showListOfRepliesUser: APIBLMShowListOfRepliesExtendedUserDuplicate.fromJson(parsedJson['user']),
      showListOfRepliesReplyBody: parsedJson['body'] ?? '',
      showListOfRepliesCreatedAt: parsedJson['created_at'] ?? '',
    );
  }
}

class APIBLMShowListOfRepliesExtendedUserDuplicate{
  int showListRepliesUserUserId;
  String showListRepliesUserFirstName;
  String showListRepliesUserLastName;
  String showListRepliesUserImage;
  int showListRepliesUserAccountType;
  APIBLMShowListOfRepliesExtendedUserDuplicate({required this.showListRepliesUserUserId, required this.showListRepliesUserFirstName, required this.showListRepliesUserLastName, required this.showListRepliesUserImage, required this.showListRepliesUserAccountType});

  factory APIBLMShowListOfRepliesExtendedUserDuplicate.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowListOfRepliesExtendedUserDuplicate(
      showListRepliesUserUserId: parsedJson['id'],
      showListRepliesUserFirstName: parsedJson['first_name'] ?? '',
      showListRepliesUserLastName: parsedJson['last_name'] ?? '',
      showListRepliesUserImage: parsedJson['image'] ?? '',
      showListRepliesUserAccountType: parsedJson['account_type'],
    );
  }
}