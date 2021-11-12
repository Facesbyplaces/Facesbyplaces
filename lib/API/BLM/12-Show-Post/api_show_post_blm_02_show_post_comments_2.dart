import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIBLMShowListOfCommentsDuplicate> apiBLMShowListOfCommentsDuplicate({required int postId}) async{
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

  var response = await dioRequest.get('https://www.facesbyplaces.com/api/v1/posts/index/comments2/$postId',
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
    return APIBLMShowListOfCommentsDuplicate.fromJson(newData);
  }else{
    throw Exception('Error occurred: ${response.statusMessage}');
  }
}

class APIBLMShowListOfCommentsDuplicate{
  List<APIBLMShowListOfCommentsExtendedDuplicate> blmCommentsList;
  APIBLMShowListOfCommentsDuplicate({required this.blmCommentsList});

  factory APIBLMShowListOfCommentsDuplicate.fromJson(Map<String, dynamic> parsedJson){
    var newList1 = parsedJson['comments'] as List;
    List<APIBLMShowListOfCommentsExtendedDuplicate> commentsList = newList1.map((i) => APIBLMShowListOfCommentsExtendedDuplicate.fromJson(i)).toList();

    return APIBLMShowListOfCommentsDuplicate(
      blmCommentsList: commentsList,
    );
  }
}

class APIBLMShowListOfCommentsExtendedDuplicate{
  int showListOfCommentsCommentId;
  int showListOfCommentsPostId;
  APIBLMShowListOfCommentsExtendedUserDuplicate showListOfCommentsUser;
  String showListOfCommentsCommentBody;
  String showListOfCommentsCreatedAt;
  APIBLMShowListOfCommentsExtendedDuplicate({required this.showListOfCommentsCommentId, required this.showListOfCommentsPostId, required this.showListOfCommentsCommentBody, required this.showListOfCommentsUser, required this.showListOfCommentsCreatedAt});

  factory APIBLMShowListOfCommentsExtendedDuplicate.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowListOfCommentsExtendedDuplicate(
      showListOfCommentsCommentId: parsedJson['id'],
      showListOfCommentsPostId: parsedJson['post_id'],
      showListOfCommentsUser: APIBLMShowListOfCommentsExtendedUserDuplicate.fromJson(parsedJson['user']),
      showListOfCommentsCommentBody: parsedJson['body'] ?? '',
      showListOfCommentsCreatedAt: parsedJson['created_at'] ?? '',
    );
  }
}

class APIBLMShowListOfCommentsExtendedUserDuplicate{
  int showListOfCommentsUserId;
  String showListOfCommentsUserFirstName;
  String showListOfCommentsUserLastName;
  String showListOfCommentsUserImage;
  int showListOfCommentsUserAccountType;
  APIBLMShowListOfCommentsExtendedUserDuplicate({required this.showListOfCommentsUserId, required this.showListOfCommentsUserFirstName, required this.showListOfCommentsUserLastName, required this.showListOfCommentsUserImage, required this.showListOfCommentsUserAccountType});

  factory APIBLMShowListOfCommentsExtendedUserDuplicate.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowListOfCommentsExtendedUserDuplicate(
      showListOfCommentsUserId: parsedJson['id'],
      showListOfCommentsUserFirstName: parsedJson['first_name'] ?? '',
      showListOfCommentsUserLastName: parsedJson['last_name'] ?? '',
      showListOfCommentsUserImage: parsedJson['image'] ?? '',
      showListOfCommentsUserAccountType: parsedJson['account_type'],
    );
  }
}