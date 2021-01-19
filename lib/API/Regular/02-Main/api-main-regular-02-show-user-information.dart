import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowProfileInformation> apiRegularShowProfileInformation() async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  // print('The access token is $getAccessToken');
  // print('The uid is $getUID');
  // print('The client is $getClient');

  // print('The access token in show information is $getAccessToken');
  // print('The uid in show information is $getUID');
  // print('The client in show information is $getClient');

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/users/image_show',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  // print('The response status code of show user information is ${response.statusCode}');
  // print('The response status body of show user information is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularShowProfileInformation.fromJson(newValue);
  }else{
    throw Exception('Failed to get the user information');
  }
}

class APIRegularShowProfileInformation{
  int userId;
  String firstName;
  String lastName;
  String image;
  String email;

  APIRegularShowProfileInformation({this.userId, this.firstName, this.lastName, this.image, this.email});

  factory APIRegularShowProfileInformation.fromJson(Map<String, dynamic> parsedJson){

    var newValue = parsedJson['user'];

    return APIRegularShowProfileInformation(
      userId: newValue['id'],
      firstName: newValue['first_name'],
      lastName: newValue['last_name'],
      image: newValue['image'],
      email: newValue['email'],
    );
  }
}