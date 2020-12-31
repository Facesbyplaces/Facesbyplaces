import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularSearchUsersMain> apiRegularSearchUsers(String keywords, int page) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';
  
  final http.Response response = await http.get(
    'http://fbp.dev1.koda.ws/api/v1/search/users?page=$page&keywords=$keywords',
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
  List<APIRegularSearchUsersExtended> users;

  APIRegularSearchUsersMain({this.itemsRemaining, this.users});

  factory APIRegularSearchUsersMain.fromJson(Map<String, dynamic> parsedJson){
    var newValue = parsedJson['users'] as List;
    List<APIRegularSearchUsersExtended> newRegularList = newValue.map((e) => APIRegularSearchUsersExtended.fromJson(e)).toList();

    return APIRegularSearchUsersMain(
      itemsRemaining: parsedJson['itemsremaining'],
      users: newRegularList,
    );
  }
}

class APIRegularSearchUsersExtended{
  int userId;
  String firstName;
  String lastName;
  String email;

  APIRegularSearchUsersExtended({this.userId, this.firstName, this.lastName, this.email});

  factory APIRegularSearchUsersExtended.fromJson(Map<String, dynamic> parsedJson){

    return APIRegularSearchUsersExtended(
      userId: parsedJson['id'],
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      email: parsedJson['email'],
    );
  }
}