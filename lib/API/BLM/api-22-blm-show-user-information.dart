import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowProfileInformation> apiBLMShowProfileInformation() async{

  final sharedPrefs = await SharedPreferences.getInstance();
  var getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  var getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  var getClient = sharedPrefs.getString('blm-client') ?? 'empty';

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
    return APIBLMShowProfileInformation.fromJson(newValue);
  }else{
    throw Exception('Failed to get the user information');
  }
}

class APIBLMShowProfileInformation{
  int userId;
  String firstName;
  String lastName;
  dynamic image;

  APIBLMShowProfileInformation({this.userId, this.firstName, this.lastName, this.image});

  factory APIBLMShowProfileInformation.fromJson(Map<String, dynamic> parsedJson){

    var newValue = parsedJson['user'];

    return APIBLMShowProfileInformation(
      userId: newValue['id'],
      firstName: newValue['first_name'],
      lastName: newValue['last_name'],
      image: newValue['image'],
    );
  }
}