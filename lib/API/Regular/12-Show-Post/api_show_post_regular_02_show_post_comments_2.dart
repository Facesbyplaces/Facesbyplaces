import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularShowListOfCommentsDuplicate> apiRegularShowListOfCommentsDuplicate({required int postId}) async{
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

  print('The access token is $getAccessToken');
  print('The uid is $getUID');
  print('The client is $getClient');
  print('The post is $postId');

  var response = await dioRequest.get('https://facesbyplaces.com/api/v1/posts/index/comments2/$postId',
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
    return APIRegularShowListOfCommentsDuplicate.fromJson(newData);
  }else{
    throw Exception('Error occurred: ${response.statusMessage}');
  }
}

class APIRegularShowListOfCommentsDuplicate{
  List<APIRegularShowListOfCommentsExtendedDuplicate> almCommentsList;
  APIRegularShowListOfCommentsDuplicate({required this.almCommentsList});

  factory APIRegularShowListOfCommentsDuplicate.fromJson(Map<String, dynamic> parsedJson){
    var newList1 = parsedJson['comments'] as List;
    List<APIRegularShowListOfCommentsExtendedDuplicate> commentsList = newList1.map((i) => APIRegularShowListOfCommentsExtendedDuplicate.fromJson(i)).toList();

    return APIRegularShowListOfCommentsDuplicate(
      almCommentsList: commentsList,
    );
  }
}

class APIRegularShowListOfCommentsExtendedDuplicate{
  int showListOfCommentsCommentId;
  int showListOfCommentsPostId;
  APIRegularShowListOfCommentsExtendedUserDuplicate showListOfCommentsUser;
  String showListOfCommentsCommentBody;
  String showListOfCommentsCreatedAt;
  APIRegularShowListOfCommentsExtendedDuplicate({required this.showListOfCommentsCommentId, required this.showListOfCommentsPostId, required this.showListOfCommentsCommentBody, required this.showListOfCommentsUser, required this.showListOfCommentsCreatedAt});

  factory APIRegularShowListOfCommentsExtendedDuplicate.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowListOfCommentsExtendedDuplicate(
      showListOfCommentsCommentId: parsedJson['id'],
      showListOfCommentsPostId: parsedJson['post_id'],
      showListOfCommentsUser: APIRegularShowListOfCommentsExtendedUserDuplicate.fromJson(parsedJson['user']),
      showListOfCommentsCommentBody: parsedJson['body'] ?? '',
      showListOfCommentsCreatedAt: parsedJson['created_at'] ?? '',
    );
  }
}

class APIRegularShowListOfCommentsExtendedUserDuplicate{
  int showListOfCommentsUserId;
  String showListOfCommentsUserFirstName;
  String showListOfCommentsUserLastName;
  String showListOfCommentsUserImage;
  int showListOfCommentsUserAccountType;
  APIRegularShowListOfCommentsExtendedUserDuplicate({required this.showListOfCommentsUserId, required this.showListOfCommentsUserFirstName, required this.showListOfCommentsUserLastName, required this.showListOfCommentsUserImage, required this.showListOfCommentsUserAccountType});

  factory APIRegularShowListOfCommentsExtendedUserDuplicate.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowListOfCommentsExtendedUserDuplicate(
      showListOfCommentsUserId: parsedJson['id'],
      showListOfCommentsUserFirstName: parsedJson['first_name'] ?? '',
      showListOfCommentsUserLastName: parsedJson['last_name'] ?? '',
      showListOfCommentsUserImage: parsedJson['image'] ?? '',
      showListOfCommentsUserAccountType: parsedJson['account_type'],
    );
  }
}