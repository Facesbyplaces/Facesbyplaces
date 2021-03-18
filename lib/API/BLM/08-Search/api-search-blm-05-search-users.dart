import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIBLMSearchUsersMain> apiBLMSearchUsers({required String keywords, required int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/search/users?page=$page&keywords=$keywords',
    options: Options(
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  print('The status code of search users is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIBLMSearchUsersMain.fromJson(newData);
  }else{
    throw Exception('Failed to get the users');
  }
}

class APIBLMSearchUsersMain{
  int blmItemsRemaining;
  List<APIBLMSearchUsersExtended> blmUsers;

  APIBLMSearchUsersMain({required this.blmItemsRemaining, required this.blmUsers});

  factory APIBLMSearchUsersMain.fromJson(Map<String, dynamic> parsedJson){
    var newValue = parsedJson['users'] as List;
    List<APIBLMSearchUsersExtended> newBLMList = newValue.map((e) => APIBLMSearchUsersExtended.fromJson(e)).toList();

    return APIBLMSearchUsersMain(
      blmItemsRemaining: parsedJson['itemsremaining'],
      blmUsers: newBLMList,
    );
  }
}

class APIBLMSearchUsersExtended{
  int searchUsersUserId;
  String searchUsersFirstName;
  String searchUsersLastName;
  String searchUsersEmail;
  int searchUsersAccountType;
  String searchUsersImage;

  APIBLMSearchUsersExtended({required this.searchUsersUserId, required this.searchUsersFirstName, required this.searchUsersLastName, required this.searchUsersEmail, required this.searchUsersAccountType, required this.searchUsersImage});

  factory APIBLMSearchUsersExtended.fromJson(Map<String, dynamic> parsedJson){

    return APIBLMSearchUsersExtended(
      searchUsersUserId: parsedJson['id'],
      searchUsersFirstName: parsedJson['first_name'] != null ? parsedJson['first_name'] : '',
      searchUsersLastName: parsedJson['last_name'] != null ? parsedJson['last_name'] : '',
      searchUsersEmail: parsedJson['email'] != null ? parsedJson['email'] : '',
      searchUsersAccountType: parsedJson['account_type'],
      searchUsersImage: parsedJson['image'] != null ? parsedJson['image'] : '',
    );
  }
}