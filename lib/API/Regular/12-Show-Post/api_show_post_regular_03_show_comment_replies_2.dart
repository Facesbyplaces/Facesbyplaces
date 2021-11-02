import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularShowListOfRepliesDuplicate> apiRegularShowListOfRepliesDuplicate({required int postId}) async{
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

  var response = await dioRequest.get('https://facesbyplaces.com/api/v1/posts/index/replies2/$postId',
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
    return APIRegularShowListOfRepliesDuplicate.fromJson(newData);
  }else{
    throw Exception('Error occurred: ${response.statusMessage}');
  }
}

class APIRegularShowListOfRepliesDuplicate{
  List<APIRegularShowListOfRepliesExtendedDuplicate> almRepliesList;
  APIRegularShowListOfRepliesDuplicate({required this.almRepliesList});

  factory APIRegularShowListOfRepliesDuplicate.fromJson(Map<String, dynamic> parsedJson){
    var newList1 = parsedJson['replies'] as List;
    List<APIRegularShowListOfRepliesExtendedDuplicate> repliesList = newList1.map((i) => APIRegularShowListOfRepliesExtendedDuplicate.fromJson(i)).toList();

    return APIRegularShowListOfRepliesDuplicate(
      almRepliesList: repliesList,
    );
  }
}

class APIRegularShowListOfRepliesExtendedDuplicate{
  int showListOfRepliesReplyId;
  int showListOfRepliesCommentId;
  APIRegularShowListOfRepliesExtendedUserDuplicate showListOfRepliesUser;
  String showListOfRepliesReplyBody;
  String showListOfRepliesCreatedAt;
  APIRegularShowListOfRepliesExtendedDuplicate({required this.showListOfRepliesReplyId, required this.showListOfRepliesCommentId, required this.showListOfRepliesReplyBody, required this.showListOfRepliesUser, required this.showListOfRepliesCreatedAt});

  factory APIRegularShowListOfRepliesExtendedDuplicate.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowListOfRepliesExtendedDuplicate(
      showListOfRepliesReplyId: parsedJson['id'],
      showListOfRepliesCommentId: parsedJson['comment_id'],
      showListOfRepliesUser: APIRegularShowListOfRepliesExtendedUserDuplicate.fromJson(parsedJson['user']),
      showListOfRepliesReplyBody: parsedJson['body'] ?? '',
      showListOfRepliesCreatedAt: parsedJson['created_at'] ?? '',
    );
  }
}

class APIRegularShowListOfRepliesExtendedUserDuplicate{
  int showListRepliesUserUserId;
  String showListRepliesUserFirstName;
  String showListRepliesUserLastName;
  String showListRepliesUserImage;
  int showListOfCommentsUserAccountType;
  APIRegularShowListOfRepliesExtendedUserDuplicate({required this.showListRepliesUserUserId, required this.showListRepliesUserFirstName, required this.showListRepliesUserLastName, required this.showListRepliesUserImage, required this.showListOfCommentsUserAccountType});

  factory APIRegularShowListOfRepliesExtendedUserDuplicate.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowListOfRepliesExtendedUserDuplicate(
      showListRepliesUserUserId: parsedJson['id'],
      showListRepliesUserFirstName: parsedJson['first_name'] ?? '',
      showListRepliesUserLastName: parsedJson['last_name'] ?? '',
      showListRepliesUserImage: parsedJson['image'] ?? '',
      showListOfCommentsUserAccountType: parsedJson['account_type'],
    );
  }
}