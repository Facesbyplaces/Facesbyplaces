import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMSearchUsersMain> apiBLMSearchUsers(String keywords, int page) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  var getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  var getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  var getClient = sharedPrefs.getString('blm-client') ?? 'empty';
  
  final http.Response response = await http.get(
    'http://fbp.dev1.koda.ws/api/v1/search/users?page=$page&keywords=$keywords',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The status code on blm search user is ${response.statusCode}');
  print('The status body on blm search user is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMSearchUsersMain.fromJson(newValue);
  }else{
      throw Exception('Failed to get the user information');
    }
}

class APIBLMSearchUsersMain{
  int itemsRemaining;
  List<APIBLMSearchUsersExtended> users;

  APIBLMSearchUsersMain({this.itemsRemaining, this.users});

  factory APIBLMSearchUsersMain.fromJson(Map<String, dynamic> parsedJson){
    var newValue = parsedJson['users'] as List;
    List<APIBLMSearchUsersExtended> newBLMList = newValue.map((e) => APIBLMSearchUsersExtended.fromJson(e)).toList();

    return APIBLMSearchUsersMain(
      itemsRemaining: parsedJson['itemsremaining'],
      users: newBLMList,
    );
  }
}

class APIBLMSearchUsersExtended{

  String firstName;
  String lastName;
  String email;

  APIBLMSearchUsersExtended({this.firstName, this.lastName, this.email});

  factory APIBLMSearchUsersExtended.fromJson(Map<String, dynamic> parsedJson){

    return APIBLMSearchUsersExtended(
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      email: parsedJson['email'],
    );
  }
}