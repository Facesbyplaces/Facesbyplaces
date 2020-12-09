import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowProfileInformation> apiRegularShowProfileInformation() async{

  final sharedPrefs = await SharedPreferences.getInstance();
  var getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  var getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  var getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/users/image_show',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The status code for drawer is ${response.statusCode}');
  print('The status body for drawer is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularShowProfileInformation.fromJson(newValue);
  }else{
    throw Exception('Failed to get the user information');
  }
}

class APIRegularShowProfileInformation{
  String firstName;
  String lastName;
  dynamic image;

  APIRegularShowProfileInformation({this.firstName, this.lastName, this.image});

  factory APIRegularShowProfileInformation.fromJson(Map<String, dynamic> parsedJson){

    var newValue = parsedJson['user'];

    return APIRegularShowProfileInformation(
      firstName: newValue['first_name'],
      lastName: newValue['last_name'],
      image: newValue['image'],
    );
  }
}