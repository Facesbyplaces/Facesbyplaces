// ignore_for_file: file_names
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularShowListOfComments> apiRegularShowListOfComments({required int postId, required int page}) async{
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

  var response = await dioRequest.get('http://facesbyplaces.com/api/v1/posts/index/comments/$postId?page=$page',
    options: Options(
      followRedirects: false,
      validateStatus: (status){
        return status! < 600;
      },
      headers: <String, dynamic>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),
  );

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIRegularShowListOfComments.fromJson(newData);
  }else{
    throw Exception('Error occurred: ${response.statusMessage}');
  }
}

class APIRegularShowListOfComments{
  int almItemsRemaining;
  List<APIRegularShowListOfCommentsExtended> almCommentsList;
  APIRegularShowListOfComments({required this.almItemsRemaining, required this.almCommentsList});

  factory APIRegularShowListOfComments.fromJson(Map<String, dynamic> parsedJson){
    var newList1 = parsedJson['comments'] as List;
    List<APIRegularShowListOfCommentsExtended> commentsList = newList1.map((i) => APIRegularShowListOfCommentsExtended.fromJson(i)).toList();

    return APIRegularShowListOfComments(
      almItemsRemaining: parsedJson['itemsremaining'],
      almCommentsList: commentsList,
    );
  }
}

class APIRegularShowListOfCommentsExtended{
  int showListOfCommentsCommentId;
  int showListOfCommentsPostId;
  APIRegularShowListOfCommentsExtendedUser showListOfCommentsUser;
  String showListOfCommentsCommentBody;
  String showListOfCommentsCreatedAt;
  APIRegularShowListOfCommentsExtended({required this.showListOfCommentsCommentId, required this.showListOfCommentsPostId, required this.showListOfCommentsCommentBody, required this.showListOfCommentsUser, required this.showListOfCommentsCreatedAt});

  factory APIRegularShowListOfCommentsExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowListOfCommentsExtended(
      showListOfCommentsCommentId: parsedJson['id'],
      showListOfCommentsPostId: parsedJson['post_id'],
      showListOfCommentsUser: APIRegularShowListOfCommentsExtendedUser.fromJson(parsedJson['user']),
      showListOfCommentsCommentBody: parsedJson['body'] ?? '',
      showListOfCommentsCreatedAt: parsedJson['created_at'] ?? '',
    );
  }
}

class APIRegularShowListOfCommentsExtendedUser{
  int showListOfCommentsUserId;
  String showListOfCommentsUserFirstName;
  String showListOfCommentsUserLastName;
  String showListOfCommentsUserImage;
  int showListOfCommentsUserAccountType;
  APIRegularShowListOfCommentsExtendedUser({required this.showListOfCommentsUserId, required this.showListOfCommentsUserFirstName, required this.showListOfCommentsUserLastName, required this.showListOfCommentsUserImage, required this.showListOfCommentsUserAccountType});

  factory APIRegularShowListOfCommentsExtendedUser.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowListOfCommentsExtendedUser(
      showListOfCommentsUserId: parsedJson['id'],
      showListOfCommentsUserFirstName: parsedJson['first_name'] ?? '',
      showListOfCommentsUserLastName: parsedJson['last_name'] ?? '',
      showListOfCommentsUserImage: parsedJson['image'] ?? '',
      showListOfCommentsUserAccountType: parsedJson['account_type'],
    );
  }
}