import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowProfileFollowing> apiRegularShowProfileFollowing() async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/followers',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularShowProfileFollowing.fromJson(newValue);
  }else{
    throw Exception('Failed to get the following status');
  }
}



class APIRegularShowProfileFollowing{
  bool following;
  
  APIRegularShowProfileFollowing({this.following});

  factory APIRegularShowProfileFollowing.fromJson(Map<String, dynamic> parsedJson){

    return APIRegularShowProfileFollowing(
      following: parsedJson['follow'],
    );
  }
}