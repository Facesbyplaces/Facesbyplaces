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
  int itemsRemaining;
  List<APIBLMSearchUsersExtended> users;

  APIRegularSearchUsersMain({this.itemsRemaining, this.users});

  factory APIRegularSearchUsersMain.fromJson(Map<String, dynamic> parsedJson){
    var newValue = parsedJson['users'] as List;
    List<APIBLMSearchUsersExtended> newBLMList = newValue.map((e) => APIBLMSearchUsersExtended.fromJson(e)).toList();

    return APIRegularSearchUsersMain(
      itemsRemaining: parsedJson['itemsremaining'],
      users: newBLMList,
    );
  }
}

class APIBLMSearchUsersExtended{
  int userId;
  String firstName;
  String lastName;
  String email;

  APIBLMSearchUsersExtended({this.userId, this.firstName, this.lastName, this.email});

  factory APIBLMSearchUsersExtended.fromJson(Map<String, dynamic> parsedJson){

    return APIBLMSearchUsersExtended(
      userId: parsedJson['id'],
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      email: parsedJson['email'],
    );
  }
}