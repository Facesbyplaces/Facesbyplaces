import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularSearchUsersMain> apiRegularSearchUsers({String keywords, int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/search/users?page=$page&keywords=$keywords',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularSearchUsersMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the user information');
  }
}

class APIRegularSearchUsersMain{
  int almItemsRemaining;
  List<APIBLMSearchUsersExtended> almSearchUsers;

  APIRegularSearchUsersMain({this.almItemsRemaining, this.almSearchUsers});

  factory APIRegularSearchUsersMain.fromJson(Map<String, dynamic> parsedJson){
    var newValue = parsedJson['users'] as List;
    List<APIBLMSearchUsersExtended> newBLMList = newValue.map((e) => APIBLMSearchUsersExtended.fromJson(e)).toList();

    return APIRegularSearchUsersMain(
      almItemsRemaining: parsedJson['itemsremaining'],
      almSearchUsers: newBLMList,
    );
  }
}

class APIBLMSearchUsersExtended{
  int searchUsersId;
  String searchUsersFirstName;
  String searchUsersLastName;
  String searchUsersEmail;
  int searchUsersAccountType;
  String searchUsersImage;

  APIBLMSearchUsersExtended({this.searchUsersId, this.searchUsersFirstName, this.searchUsersLastName, this.searchUsersEmail, this.searchUsersAccountType, this.searchUsersImage});

  factory APIBLMSearchUsersExtended.fromJson(Map<String, dynamic> parsedJson){

    return APIBLMSearchUsersExtended(
      searchUsersId: parsedJson['id'],
      searchUsersFirstName: parsedJson['first_name'],
      searchUsersLastName: parsedJson['last_name'],
      searchUsersEmail: parsedJson['email'],
      searchUsersAccountType: parsedJson['account_type'],
      searchUsersImage: parsedJson['image'],
    );
  }
}