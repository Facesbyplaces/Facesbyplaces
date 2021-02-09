import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowProfileInformation> apiRegularShowProfileInformation() async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  print('The access token is $getAccessToken');
  print('The getUID is $getUID');
  print('The getClient is $getClient');

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/users/image_show',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The user information code is ${response.statusCode}');
  print('The user information body is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularShowProfileInformation.fromJson(newValue);
  }else{
    throw Exception('Failed to get the user information');
  }
}

class APIRegularShowProfileInformation{
  int showProfileInformationUserId;
  String showProfileInformationFirstName;
  String showProfileInformationLastName;
  String showProfileInformationImage;
  String showProfileInformationEmail;
  bool showProfileInformationGuest;

  APIRegularShowProfileInformation({this.showProfileInformationUserId, this.showProfileInformationFirstName, this.showProfileInformationLastName, this.showProfileInformationImage, this.showProfileInformationEmail, this.showProfileInformationGuest});

  factory APIRegularShowProfileInformation.fromJson(Map<String, dynamic> parsedJson){

    var newValue = parsedJson['user'];

    return APIRegularShowProfileInformation(
      showProfileInformationUserId: newValue['id'],
      showProfileInformationFirstName: newValue['first_name'],
      showProfileInformationLastName: newValue['last_name'],
      showProfileInformationImage: newValue['image'],
      showProfileInformationEmail: newValue['email'],
      showProfileInformationGuest: newValue['guest'],
    );
  }
}