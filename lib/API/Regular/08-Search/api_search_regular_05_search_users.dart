import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularSearchUsersMain> apiRegularSearchUsers({required String keywords, required int page}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('https://www.facesbyplaces.com/api/v1/search/users?page=$page&keywords=$keywords',
    options: Options(
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
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
    return APIRegularSearchUsersMain.fromJson(newData);
  }else{
    throw Exception('Failed to get the list of users');
  }
}

class APIRegularSearchUsersMain{
  int almItemsRemaining;
  List<APIRegularSearchUsersExtended> almSearchUsers;
  APIRegularSearchUsersMain({required this.almItemsRemaining, required this.almSearchUsers});

  factory APIRegularSearchUsersMain.fromJson(Map<String, dynamic> parsedJson){
    var newValue = parsedJson['users'] as List;
    List<APIRegularSearchUsersExtended> newBLMList = newValue.map((e) => APIRegularSearchUsersExtended.fromJson(e)).toList();

    return APIRegularSearchUsersMain(
      almItemsRemaining: parsedJson['itemsremaining'],
      almSearchUsers: newBLMList,
    );
  }
}

class APIRegularSearchUsersExtended{
  int searchUsersId;
  String searchUsersFirstName;
  String searchUsersLastName;
  String searchUsersEmail;
  int searchUsersAccountType;
  String searchUsersImage;
  APIRegularSearchUsersExtended({required this.searchUsersId, required this.searchUsersFirstName, required this.searchUsersLastName, required this.searchUsersEmail, required this.searchUsersAccountType, required this.searchUsersImage});

  factory APIRegularSearchUsersExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularSearchUsersExtended(
      searchUsersId: parsedJson['id'],
      searchUsersFirstName: parsedJson['first_name'] ?? '',
      searchUsersLastName: parsedJson['last_name'] ?? '',
      searchUsersEmail: parsedJson['email'] ?? '',
      searchUsersAccountType: parsedJson['account_type'],
      searchUsersImage: parsedJson['image'] ?? '',
    );
  }
}